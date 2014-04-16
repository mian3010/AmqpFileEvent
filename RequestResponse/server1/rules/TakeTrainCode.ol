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

include "../activities/AbstractActivity.iol"
include "console.iol"
include "runtime.iol"

include "../TrainStation.iol"
include "../locations.iol"

outputPort TrainStation {
Location: Location_TrainStation
Protocol: sodep
Interfaces: TrainStationInterface
}

init
{
	with( varNames ) {
		.name[0] = "trainNumber";
		.name[1] = "from";
		.name[2] = "to"
	};
	with( nfp ) {
		.cost = 62; // Euros
		.nfp.time = 103 // Minutes
	}
}

define onRun
{
	println@Console( "New high speed train selected" )();
	println@Console( "Buying train ticket..." )();
	get@State( "trainNumber" )( buyRequest.trainNumber );
	get@State( "from" )( buyRequest.from );
	get@State( "to" )( buyRequest.to );
	buyTicket@TrainStation( buyRequest )()
}