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

include "AdaptationServer.iol"
include "locations.iol"
include "AdaptationManager.iol"
include "State.iol"

execution { concurrent }

outputPort State {
Interfaces: StateInterface
}

inputPort AdaptationManagerInput {
Location: Location_AdaptationManager
Protocol: sodep
Interfaces: AdaptationServerInterface, AdaptationManagerInterface
Aggregates: State
}

outputPort AdaptationServer {
Interfaces: AdaptationServerInterface
}

embedded {
Jolie:
	"State.ol" in State
}

init
{
	servers -> global.servers
}

main
{
	[ registerAdaptationServer( binding )() {
		synchronized( Servers ) {
			servers.(binding.location) << binding
		}
	} ] { nullProcess }

	[ checkForUpdate( request )( response ) {
		synchronized( Servers ) {
			foreach( n : servers ) {
				b[i++] << servers.(n)
			}
		};
		for( i = 0, i < #b && !is_defined( response ), i++ ) {
			AdaptationServer << b[i];
			checkForUpdate@AdaptationServer( request )( response )
		}
	} ] { nullProcess }
}
