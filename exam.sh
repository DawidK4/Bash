#!/bin/bash

deleted_text=0
executed_files=0
crashed_files=0
error_files=0
error_log="errors.log"
summary_log="summary.log"

echo "Error log - $(date)" > "$error_log"
echo "Summary log - $(date)" > "$summary_log"

echo "Processing files..."

for file in *; do 
    if [[ -f "$file" ]]; then 
        if [[ "$file" == *.txt ]]; then 
            if rm "$file" 2>> "$error_log"; then
                ((deleted_text++))
            else 
                echo "Failed to delete $file" >> "$error_log"
            fi
        elif [[ -x "$file" ]]; then 
            ((executed_files++))
            "./$file" >> /dev/null 2>> "$error_log" 
            # >> /dev/null
            # – Redirects standard output (stdout) to /dev/null, which discards it. 
            # This prevents any normal output from appearing.
            exit_status=$? # Captures the exit status of the last executed command
            # 0 - success, not 0 - an error occured 
            if [[ $exit_status -ne 0 ]]; then 
                ((crashed_files++))
                echo "Execution failed: $file (Exit code: $exit_status)" >> "$error_log"
            fi
        fi
    fi
done 

# It does not print the matching lines—only the count of how many times the pattern appears.
# Counts all lines in error.log 
error_files=$(grep -c "" "$error_log")

char_count=$(wc -m < "$error_log")
word_count=$(wc -w < "$error_log")
line_count=$(wc -l < "$error_log")

echo "Deleted .txt files: $deleted_txt" >> "$summary_log"
echo "Executed files: $executed_files" >> "$summary_log"
echo "Crashed executions: $crashed_files" >> "$summary_log"
echo "Error log entries: $error_files" >> "$summary_log"
echo "Error log - Characters: $char_count, Words: $word_count, Lines: $line_count" >> "$summary_log"

echo "Processing complete. Check $error_log and $summary_log."
