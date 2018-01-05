library(gh)
library("glue")

# Submit an assignment via the API. Creates a release and an issue
submit_assignment <- function(corrected = FALSE) {
  owner <- "UW-POLS501"
  repo <- "2018"
  assignees <- list("calvinhgarner", "jrnold")
  # Assumes master/head to get latest repo. Could also test by time.
  latest <- gh("/repos/:owner/:repo/commits",
               owner = owner, repo = repo)[[1]]

  # create a tag
  this automatically creates a release
  tagname <- "submission"
  gh("POST /repos/:owner/:repo/git/refs",
            owner = owner, repo = repo,
            ref = glue("refs/tags/{tagname}"),
            sha = latest[["sha"]])

    # Create issue
   gh("POST /repos/:owner/:repo/issues",
      owner = owner, repo = repo,
      title = if (corrected) "Review Corrections" else "Review Submission",
      body = glue("Please review submission {latest$sha}."),
      assignees = assignees)
}

# TODO: adjust code. Find fork, create ref, submit PR.
