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

include "AbstractActivity.iol"
include "console.iol"
include "runtime.iol"

include "../BusStation.iol"
include "../locations.iol"

outputPort BusStation {
Location: Location_BusStation
Protocol: sodep
Interfaces: BusStationInterface
}

init
{
	with( varNames ) {
		.name[0] = "busNumber";
		.name[1] = "busFrom";
		.name[2] = "busTo"
	};
	with( nfp ) {
		.cost = 1; // Euros
		.time = 25 // Minutes
	}
}

define onRun
{
	println@Console( "Buying bus ticket..." )();
	get@State( "busNumber" )( buyRequest.busNumber );
	get@State( "busFrom" )( buyRequest.from );
	get@State( "busTo" )( buyRequest.to );
	buyTicket@BusStation( buyRequest )()
}