.PHONY: create_day-X all

create_day :
	@echo "Creating directory by template for day $(ARGS)"
	@cp -r dayX day${ARGS}
	@mv day${ARGS}/dayX.dart day${ARGS}/day${ARGS}.dart
	$(MAKE) populate_example_file $(ARGS)

#TODO(mfarizon): This is not working very well for now
populate_example_file :
	curl https://adventofcode.com/2022/day/$(ARGS) > day$(ARGS)/full_problem_$(ARGS).html
	sed -n '/<pre><code>/,/<\/code><\/pre>/p' day$(ARGS)/full_problem_$(ARGS).html > day$(ARGS)/example_input.txt

	# tr --delete '\n' < full_problem_$(ARGS).html
	# awk 'BEGIN { FS = "<pre><code>" } ; { print $1 }' 
	# awk -f full_problem_$(ARGS).html --field-separator "<pre><code>" > echo 

