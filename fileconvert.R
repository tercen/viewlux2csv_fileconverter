
#select file

in_file_name <- file.choose()

# original filname
get_name_parts <- function(a_file_name) {
  basename <- basename(a_file_name)
  # get last "."
  ext <- tail(strsplit(basename, "\\.")[[1]], n=1L)
  prefix <- strsplit(basename, "_")[[1]][1]
  # path
  path_sans_base_and_ext <-substr(a_file_name, start=1, stop = (nchar(a_file_name)-nchar(basename))) 
  basename_sans_ext <- substr(start = 1, stop = (nchar(basename)-nchar(ext)-1), basename)
  path_without_ext <- paste0(path_sans_base_and_ext, basename_sans_ext)
  return(list(basename = basename, path_sans_base_and_ext=path_sans_base_and_ext, path_without_ext = path_without_ext, ext = ext, prefix = prefix))
}

# make 96 plate annotation
data_dummy <- rep(1,96)
dim(data_dummy) <- c(8,12)
row_col_name <- which( !(is.na(data_dummy)), arr.ind = T)
row_letter <- rep(LETTERS[1:8], 12)
col_name <- formatC(row_col_name[,2], width = 2, format = "d", flag = "0")
well_name <- paste0(row_letter,col_name)


# filename feedback
file_part <- get_name_parts(in_file_name)
print (paste("filename is", file_part$basename))

print (paste("processing filename", file_part$basename))

print("reading started...")
print("...it may take some time..")
print("...please wait...")

lines <- readLines(in_file_name, encoding = "UTF-8" )

# find results section
results_idx <- grep( pattern="^;5 Results in plate format", lines)

# find all plates
plate_idx <- grep( pattern="^;Plate\t", lines)
plate_idx <- plate_idx[plate_idx >= results_idx]

# find the data 
exposure_idx <- grep( pattern="^;Exposure 1$", lines)

# only look at data in results section
exposure_idx <- exposure_idx[exposure_idx >= results_idx]

# indicate to user how many plates
print(paste("found plates at lines", plate_idx))
  
# calculate number of plates
num_plates  = length(plate_idx)

# begin processing plates
print(paste("splitting file into",num_plates,"plates"))
  
  for (i in 1:num_plates) {
    
    plate_datetime <- strsplit(x=lines[plate_idx[i]+2], split=" ")
    plate_datetime <- tail(unlist(plate_datetime),2)
    
    plate_date <- plate_datetime[1]
    plate_time <- plate_datetime[2]
    plate_date <- as.Date(plate_date, "%m/%d/%Y")
    plate_time <- gsub(pattern=":", replacement="",plate_time)
    
    plate_id <- paste0(format(plate_date,"%Y%m%d"),"-", plate_time)
    run_id <- ifelse(i == 1, plate_id, run_id)
    
    # get data
    plate_text <- lines[(exposure_idx[i]+1): (exposure_idx[i]+8)]
    plate_data <- read.delim(text=plate_text, sep="\t", header = FALSE, check.names = FALSE)
    plate_data <- plate_data[,-13]
    
    # make it long
    plate_data <- stack(plate_data)
    
    # add all other annotation
    plate_data <- data.frame(run_id, 
                             plate_id = plate_id, 
                             well_id = paste(run_id, i, well_name, sep="-"), 
                             row_col_name,
                             plate_num = paste("plate",i), 
                             well_name, 
                             measurement = plate_data[,1], 
                             sample_id = "")
    
    if (i == 1) all_plate_data = plate_data else all_plate_data = rbind(all_plate_data, plate_data)
    
    dir_plate_name  <- paste0(file_part$path_sans_base_and_ext, run_id)
    if (!dir.exists(dir_plate_name)) dir.create(dir_plate_name)
      
    file_plate_name <- file.path(dir_plate_name, paste0(run_id,"-plate-",i, ".csv"))
    
    if (!file.exists(file_plate_name)) write.table(plate_data, file = file_plate_name , sep=",", na ="", row.names = FALSE)
    
    
    print (paste("plate ", i, "processed"))

  }

file_name      <- file.path(dir_plate_name, paste0(run_id, ".csv"))
# file_name      <- paste0(file_part$path_sans_base_and_ext, run_id, ".csv")

#file_name_annot<- paste0(file_part$path_sans_base_and_ext, run_id, "-annot.csv")
  
if (!file.exists(file_name))       write.table(all_plate_data, file = file_name , sep=",", na ="", row.names = FALSE)
  
#if (!file.exists(file_name_annot)) write.table(all_plate_data["well_id"], file = file_name_annot, sep=",", na ="", row.names = FALSE) 
  
print ("conversion finished")
