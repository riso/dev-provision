SRCDIR			:= puppet
DIST_FILENAME	:= puppet
DISTDIR 		:= dist
BUCKET			:= dev-provision


all: aws

aws: zip
	aws s3 cp $(DISTDIR)/$(DIST_FILENAME).tar.gz s3://$(BUCKET)/$(DIST_FILENAME).tar.gz

zip: $(DISTDIR)
	tar cfz $(DISTDIR)/puppet.tar.gz puppet/

$(DISTDIR):
	mkdir -p $(DISTDIR)

clean:
	rm -rf $(DISTDIR)
