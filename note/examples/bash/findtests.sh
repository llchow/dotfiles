find src -name "*.t.h" -exec grep -h 'class .*:TestSuite' {} + | sed 's/^[ \t]*//g' | cut -d' ' -f2 | tr -d : > testsuites
