
# test.examples <- function() {
#     checkEquals(6, factorial(3))
#     checkEqualsNumeric(6, factorial(3))
#     checkIdentical(6, factorial(3))
#     checkTrue(2 + 2 == 4, 'Arithmetic works')
#     checkException(log('a'), 'Unable to take the log() of a string')
# }

test.makeStdsAndMeansSubset <- function() {
    DEACTIVATED("No tests here yet")
}

# test number of rows found for subject + activity + measurement against libre office
test.getStdsAndMeansSubset <- function() {
    cleanUp("")
    ss <- getStdsAndMeansSubset()
    # restrict to subject 2's STANDING measurements
    obs <- subset(ss, activity == "STANDING" & subject == 2)
    # parens & commas in col names have been converted to dots by read.table(check.names = T)
    z_gravity_means <- obs[, "angle.Z.gravityMean."]
    checkEquals(54, length(z_gravity_means))
}

# test results of getTidyData against some values calculated manually in libre office calc
test.getTidyData <- function() {
    cleanUp("", "", "")
    t <- getTidyData()
    # restrict to subject 2's STANDING measurements
    obs <- subset(t, activity == "STANDING" & subject == 2)
    # parens & commas in col names have been converted to dots by read.table(check.names = T)
    checkEquals(obs[1, "angle.Z.gravityMean."], -0.0678959806)
}
