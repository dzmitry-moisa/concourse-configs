#!/bin/sh

echo "Executing unit tests..."

mkdir unit-test-reports
echo "file1" > unit-test-reports/file1
echo "file2" > unit-test-reports/file2
echo "file3" > unit-test-reports/file3
echo "file4" > unit-test-reports/file4

ls unit-test-reports/*