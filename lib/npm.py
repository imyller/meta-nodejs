# ex:ts=4:sw=4:sts=4:et
# -*- tab-width: 4; c-basic-offset: 4; indent-tabs-mode: nil -*-
"""
BitBake 'Fetch' implementation for npm

"""

# Copyright (C) 2014 Ilkka Myller
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# Based on functions from the base bb module, Copyright 2003 Holger Schurig

import os
import logging
import bb
import urllib
from   bb import data
from   bb.fetch2 import FetchMethod
from   bb.fetch2 import FetchError
from   bb.fetch2 import logger
from   bb.fetch2 import runfetchcmd


class NPM(FetchMethod):
    """Class to fetch packages via 'npm'"""

    def supports(self, url, ud, d):
        """
    	Check to see if a given url can be fetched with npm.
        """
        return ud.type in ['npm']

    def supports_checksum(self, ud):
        return False

    def urldata_init(self, ud, d):
        ud.packagename = urllib.unquote(ud.url.split("://")[1].split(";")[0])
        if 'tag' in ud.parm:
            ud.pkgdir = ud.packagename + "_" + ud.parm['tag']
            ud.fetchname = ud.packagename + '@' + ud.parm['tag']
        elif 'version' in ud.parm:
            ud.pkgdir = ud.packagename + "_" + ud.parm['version']
            ud.fetchname = ud.packagename + '@' + ud.parm['version']
        else:
            ud.pkgdir = ud.packagename
            ud.fetchname = ud.packagename
        ud.npmdir = d.getVar("NPMDIR", True) or (d.getVar("DL_DIR", True) + os.sep + "npm" + os.sep)
        ud.installdir = os.path.join(ud.npmdir, ud.pkgdir)
        ud.localfile = ud.installdir

    def localpath(self, url, ud, d):
        return ud.installdir

    def download(self, uri, ud, d):
        """Fetch packages"""
        fetchcmd = ( d.getVar("NPM", True) or "npm" ) + " "
        fetchcmd += d.getVar("NPM_ARCHFLAGS", True) or ""
        fetchcmd += " install " + ud.fetchname
        fetchcmd += " --force"
        if not os.path.exists(ud.installdir):
            bb.utils.mkdirhier(ud.installdir)
        os.chdir(ud.installdir)
        logger.info("npm install " + uri)
        logger.debug(2, "executing " + fetchcmd)
        bb.fetch2.check_network_access(d, fetchcmd)
        runfetchcmd(fetchcmd, d, quiet=False)
        return True

    def unpack(self, ud, destdir, d):
        """ unpack the fetched package to destdir"""
        subdir = ud.parm.get("subpath", "")
        if subdir != "":
            def_destsuffix = os.path.basename(subdir) + os.sep
        else:
            def_destsuffix = "npm" + os.sep
        destsuffix = ud.parm.get("destsuffix", def_destsuffix)
        destdir = ud.destdir = os.path.join(destdir, destsuffix)
        if os.path.exists(destdir):
            bb.utils.prunedir(destdir)
        else:
            bb.utils.mkdirhier(destdir)
        runfetchcmd("cp -r " + os.path.join(ud.installdir,
                                            "node_modules" + os.sep + ud.packagename) + " " + ud.destdir + os.sep, d)
        if ( subdir == "" ) and ( os.path.exists(os.path.join(ud.installdir, "node_modules" + os.sep + ".bin")) ):
            runfetchcmd(
                "cp -r " + os.path.join(ud.installdir, "node_modules" + os.sep + ".bin") + " " + ud.destdir + os.sep, d)
        return True

    def clean(self, ud, d):
        """ clean the npm directory """
        bb.utils.remove(ud.localpath, True)