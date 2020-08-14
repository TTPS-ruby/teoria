all: sinatra-test.zip sinatra-template.zip
sinatra-test.zip: sinatra-test/*
		zip -r $@ $(basename $@)
sinatra-template.zip: sinatra-template/*
		zip -r $@ $(basename $@)
clean: *zip
		rm -f *zip
