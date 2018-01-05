# Miscellaneous stuff with git
library("gh")

org <- "UW-POLS501"
STUDENT_TEAM <- "Winter 2018 students"

# list members
gh("/orgs/:org/members", org = org)

# list teams
teams <- gh("/orgs/:org/teams", org = org)
# get team for Winter 2018 students
student_team <- keep(teams, ~ .$name == STUDENT_TEAM)[[1]]

# list id members
#
# - instructors have role="maintainer"
# - students have role="member"
student_team_members <- gh("/teams/:id/members", id = student_team$id,
                           role = "member")

# get list of usernames
student_usernames <- map_chr(student_team_members, "login")

# TODO: create a team for each student

# TODO: create a repo for each student


