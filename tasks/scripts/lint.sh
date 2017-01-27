#!/bin/sh

echo "Running lint tests..."

mkdir lint-reports

echo "Report 1" > lint-reports/report_1.txt
echo "Report 2" > lint-reports/report_2.txt
echo "Report 3" > lint-reports/report_3.txt

ls lint-reports/*