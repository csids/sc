.onLoad <- function(libname, pkgname) {
  config$tasks <- TaskManager$new()

  check_env_vars()

  set_computer_type()
  set_progressr()
  set_path()
  set_plnr()

  # we need to implement lazy loading when we have more time
  try(set_db(), silent = T)

  invisible()
}

check_env_vars <- function() {
  needed <- c(
    "SYKDOMSPULSEN_DB_DRIVER",
    "SYKDOMSPULSEN_DB_SERVER",
    "SYKDOMSPULSEN_DB_PORT",
    "SYKDOMSPULSEN_DB_USER",
    "SYKDOMSPULSEN_DB_PASSWORD",
    "SYKDOMSPULSEN_DB_DB",
    "SYKDOMSPULSEN_DB_TRUSTED_CONNECTION",
    "SYKDOMSPULSEN_PRODUCTION",
    "SYKDOMSPULSEN_PATH_INPUT",
    "SYKDOMSPULSEN_PATH_OUTPUT"
  )

  # for(i in needed){
  #   getval <- Sys.getenv(i)
  #   if(getval==""){
  #     packageStartupMessage(crayon::red(glue::glue("{i}=''")))
  #   } else {
  #     if(stringr::str_detect(i,"PASSWORD")) getval <- "*****"
  #     packageStartupMessage(crayon::blue(glue::glue("{i}='{getval}'")))
  #   }
  # }
  # packageStartupMessage(glue::glue("spulscore: {utils::packageVersion('sc')}"))
}

set_computer_type <- function() {
  if (Sys.getenv("SYKDOMSPULSEN_PRODUCTION") == "1") {
    config$is_production <- TRUE
  }
}

set_progressr <- function() {
  options("progressr.enable" = TRUE)
  progressr::handlers(
    progressr::handler_progress(
      format = "[:bar] :current/:total (:percent) in :elapsedfull, eta: :eta\n",
      clear = FALSE
    )
  )
}

set_path <- function() {
  config$path_input <- Sys.getenv("SYKDOMSPULSEN_PATH_INPUT")
  config$path_output <- Sys.getenv("SYKDOMSPULSEN_PATH_OUTPUT")
}

set_plnr <- function() {
  plnr::set_opts(force_verbose = TRUE)
}
