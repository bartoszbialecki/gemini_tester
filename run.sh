#!/usr/bin/env bash

robot --outputdir results -v VALID_USERNAME:${GEMINI_TESTER_USERNAME} -v VALID_PASSWORD:${GEMINI_TESTER_PASSWORD} test_cases
