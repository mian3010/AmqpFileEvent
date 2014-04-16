/***************************************************************************
 *   Copyright (C) 2009-2010 by Fabrizio Montesi <famontesi@gmail.com>     *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU Library General Public License as       *
 *   published by the Free Software Foundation; either version 2 of the    *
 *   License, or (at your option) any later version.                       *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public Lictypemense for more details.                     *
 *                                                                         *
 *   You should have received a copy of the GNU Library General Public     *
 *   License along with this program; if not, write to the                 *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 *                                                                         *
 *   For details about the authors of this software, see the AUTHORS file. *
 ***************************************************************************/

constants {
	Location_Client = "socket://localhost:9020"
}

include "AbstractClient.iol"

main
{
	println@Console( "Client started" )();

	var = "trainNumber"; var.value = 73;
	set@State( var )();
	var = "from"; var.value = "Bologna";
	set@State( var )();
	var = "to"; var.value = "Trento";
	set@State( var )();

	var = "busNumber"; var.value = 13;
	set@State( var )();
	var = "busFrom"; var.value = "Trento Train Station";
	set@State( var )();
	var = "busTo"; var.value = "University of Trento";
	set@State( var )();

	run@ActivityManager( "GoToMeeting" )()
}
