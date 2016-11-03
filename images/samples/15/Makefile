all: 00-intro-ar.zip 01-migrations.zip 02-validaciones.zip

00-intro-ar.zip: 00-intro-ar/*
		zip -r $@ $(basename $@)
01-migrations.zip: 01-migrations/*
		zip -r $@ $(basename $@)
02-validaciones.zip: 02-validaciones/*
		zip -r $@ $(basename $@)

clean: *zip
		rm -f *zip
