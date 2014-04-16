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

include "../TaxiStation.iol"
include "../locations.iol"

outputPort TaxiStation {
Location: Location_TaxiStation
Protocol: sodep
Interfaces: TaxiStationInterface
}

init
{
	with( varNames ) {
		.name[0] = "busNumber";
		.name[1] = "busFrom";
		.name[2] = "busTo"
	};
	with( nfp ) {
		.cost = 20; // Euros
		.nfp.time = 15 // Minutes
	}
}

define onRun
{
	println@Console( "Taxi selected instead of bus" )();
	println@Console( "Booking taxi..." )();
	get@State( "busFrom" )( bookRequest.from );
	get@State( "busTo" )( bookRequest.to );
	bookTaxi@TaxiStation( bookRequest )()
}