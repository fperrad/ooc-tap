
.PHONY: test_rock test_sdk

test_rock:
#	prove --exec="rock -r" $@/*.ooc
	perl test/harness "$@/*.ooc"

test_sdk:
#	prove --exec="rock -r -sourcepath=. -sourcepath=source" $@/*.ooc
	perl test/harness "$@/*.ooc"

CODING_STD := \
  LineLength \
  HardTabs \
  TrailingSpace \
  CuddledElse \
  Parentheses \


codingstd: ../ooc-codingstd
	prove --exec="rock -r -sourcepath=../ooc-codingstd/source" $(CODING_STD)

../ooc-codingstd:
	cd .. && git clone git://github.com/fperrad/ooc-codingstd.git

README.html: README.md
	Markdown.pl README.md > README.html

clean:
	rm -rf *_tmp/ .libs/
	rm -f $(CODING_STD)
	rm -f README.html
