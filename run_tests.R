
library(RUnit)

source('run_analysis.R')

test.suite <- defineTestSuite("test coursera-getdata-009 course project",
                              dir = file.path("tests"),
                              testFileRegexp = "^test_\\w+\\.R$")

test.result <- runTestSuite(test.suite)

printTextProtocol(test.result)
