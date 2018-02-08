#!/usr/bin/env Rscript
#' Clone all forks or a repo (but meant for assignment)
suppressPackageStartupMessages({
  library("purrr")
  library("gh")
  library("git2r")
})

#' Download all forks of a repo
#'
#' For the GitHub organization \code{org}, for all members of
#' the team \code{team}, download the their project directory, which is
#' named \code{'org/:studentname'}.
#'
#' @param repo string. Repository Name
#' @param use_ssh flag. If \code{TRUE}, the use SSH to clone the directories,
#'    else use HTTPS.
#' @returns A list of \code{git_repository} objects
#'
clone_all_forks <- function(owner, repo, path = ".", use_ssh = TRUE) {
  forks <- gh("/repos/:owner/:repo/forks", owner = owner, repo = repo)
  # TODO: could filter forks by whether user is a student?
  url_key <- if (use_ssh) "ssh_url" else "clone_url"

  # create path dir if it doesn't exist
  dir.create(file.path(path, repo), recursive = TRUE, showWarnings = FALSE)

  out <- list()
  for (i in seq_along(forks)) {
    fork <- forks[[i]]
    url <- fork[[url_key]]
    fork_owner <- fork[["owner"]][["login"]]
    local_path <- file.path(repo, fork_owner)
    if (!dir.exists(local_path)) {
      message(glue("Cloning {url} to {local_path}."))
      out[[url]] <- git2r::clone(url, local_path)
    } else {
      warning(glue("WARNING: Not cloning {url} because {local_path}",
                   " already exists."))
      out[[url]] <- tryCatch({
        repository(local_path)
      }, error = function(e) {
        print("ERROR: {local_path} is not a git repository")
        NULL
      })
    }
  }
  out
}



