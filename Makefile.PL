#!/usr/bin/perl

# Copyright 2007, 2008 Kevin Ryde

# This file is part of Gtk2-Ex-TreeModelFilter-DragDest.
#
# Gtk2-Ex-TreeModelFilter-DragDest is free software; you can redistribute it
# and/or modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2, or (at your
# option) any later version.
#
# Gtk2-Ex-TreeModelFilter-DragDest is distributed in the hope that it will
# be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
# Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with Gtk2-Ex-TreeModelFilter-DragDest.  If not, see
# <http://www.gnu.org/licenses/>.

use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile
  (NAME         => 'Gtk2-Ex-TreeModelFilter-DragDest',
   ABSTRACT     => 'Add drag destination capability to TreeModelFilter objects.',
   VERSION_FROM => 'lib/Gtk2/Ex/TreeModelFilter/DragDest.pm',
   AUTHOR       => 'Kevin Ryde <user42@zip.com.au>',
   LICENSE      => 'gpl',
   SIGN         => 1,

   PREREQ_PM    => {
                    # minimum 1.100 for TreeDragDest in Perl (though quite
                    # probably something newer needed in practice)
                    'Gtk2' => '1.100',

                    # actually Gtk2 requires perl 5.8, which has
                    # Scalar::Util builtin already
                    'Scalar::Util' => 0,
                   },

   EXTRA_META => <<'HERE',
no_index:
    directory:
        - devel
resources:
    homepage: http://www.geocities.com/user42_kevin/gtk2-ex-treemodelfilter-dragdest/index.html
HERE
  );

sub MY::postamble {
  return <<'MAKE_FRAG';

CHECKFILES = $(TO_INST_PM) t/*.t examples/*.pl devel/*.pl
lint:
	perl -MO=Lint $(CHECKFILES)
	podchecker    $(CHECKFILES)
pc:
	perlcritic $(CHECKFILES)

myman:
	mv MANIFEST MANIFEST.old
	touch SIGNATURE
	(make manifest 2>&1; diff -u MANIFEST.old MANIFEST) |less

# find files in the dist with mod times this year, but without this year in
# the copyright line
copyright-years-check:
	year=`date +%Y`; \
	tar tvfz Gtk2-Ex-TreeModelFilter-DragDest-$(VERSION).tar.gz \
	| grep $$year- \
	| sed 's:^.*Gtk2-Ex-TreeModelFilter-DragDest-$(VERSION)/::' \
	| (result=0; \
	  while read i; do \
	    case $$i in \
	      '' | */ \
	      | debian/changelog | debian/compat | debian/control \
	      | t/pod.t \
	      | COPYING | MANIFEST* | SIGNATURE | META.yml) \
	      continue ;; \
	    esac; \
	    if test -e "$(srcdir)/$$i"; then f="$(srcdir)/$$i"; \
	    else f="$$i"; fi; \
	    if ! grep -q "Copyright.*$$year" $$f; then \
	      echo "$$i:1: this file"; \
	      grep Copyright $$f; \
	      result=1; \
	    fi; \
	  done; \
	  exit $$result)

debug-constants-check:
	if egrep -n 'DEBUG => [^0]' $(TO_INST_PM); then exit 1; else exit 0; fi


MAKE_FRAG
}
