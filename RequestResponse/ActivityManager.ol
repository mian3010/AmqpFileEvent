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

include "runtime.iol"
include "ActivityManager.iol"
include "Activity.iol"
include "file.iol"
include "locations.iol"
include "AdaptationManager.iol"
include "State.iol"
include "console.iol"
include "Comparator.iol"

execution { concurrent }

inputPort ActivityManagerInput {
Location: "local"
Interfaces: ActivityManagerInterface
RequestResponse:
	setClientLocation(any)(void)
}

outputPort Activity {
Interfaces: ActivityInterface
}

outputPort AdaptationManager {
Location: Location_AdaptationManager
Protocol: sodep
Interfaces: AdaptationManagerInterface
}

outputPort State {
Location: "local"
Protocol: sodep
Interfaces: StateInterface
}

outputPort Comparator {
Interfaces: ComparatorInterface
}

init
{
	setClientLocation( clientLocation )() { nullProcess };
	State.location = clientLocation;
	getLocalLocation@Runtime()( global.myLocation );

	s.type = "Jolie";
	s.filepath = "activities/TakeTrain.ol";
	loadEmbeddedService@Runtime( s )( global.activities.TakeTrain );

	s.filepath = "activities/TakeTrainComparator.ol";
	loadEmbeddedService@Runtime( s )( global.activities.TakeTrain.comparator );

	s.type = "Jolie";
	s.filepath = "activities/GoToMeeting.ol";
	loadEmbeddedService@Runtime( s )( global.activities.GoToMeeting );

	//s.filepath = "activities/TakeTrainComparator.ol";
	//loadEmbeddedService@Runtime( s )( global.activities.TakeTrain.comparator );

	s.type = "Jolie";
	s.filepath = "activities/TakeBus.ol";
	loadEmbeddedService@Runtime( s )( global.activities.TakeBus );

	s.filepath = "activities/TakeBusComparator.ol";
	loadEmbeddedService@Runtime( s )( global.activities.TakeBus.comparator );

	undef( s )
}

define selectActivity
{
	synchronized( Activities ) {
		Activity.location = global.activities.(activityName)
	}
}

define selectComparator
{
	synchronized( Activities ) {
		Comparator.location = global.activities.(activityName).comparator
	}
}

define updateActivity
{
	synchronized( Activities ) {
		f.filename = "tmp/" + activityName + ".ol";
		f.content = newActivity;
		writeFile@File( f )();
		s.type = "Jolie";
		s.filepath = f.filename;
		loc = global.activities.(activityName);
		callExit@Runtime( loc )();
		loadEmbeddedService@Runtime( s )( loc );
		global.activities.(activityName) = loc
	};
	selectActivity
}

main
{
	[ run( activityName )( response ) {
		println@Console( "Entering activity " + activityName )();
		selectActivity;
		getVariableNames@Activity()( event.variableNames );
		event.client = clientLocation;
		event.activityName = activityName;
		println@Console( "\tAsking the adaptation manager for updates" )();
		checkForUpdate@AdaptationManager( event )( newActivity );
		if ( is_defined( newActivity ) ) {
			println@Console( "\tUpdate accepted" )();
			updateActivity
		};
		runRequest.stateLocation = State.location;
		runRequest.activityManagerLocation = global.myLocation;
		println@Console( "\tExecuting activity" )();
		run@Activity( runRequest )()
	} ] { nullProcess }

	[ checkUpdateNFP( request )( response ) {
		println@Console( "\tEvaluating user preferences" )();
		activityName = request.activityName;
		selectActivity;
		getNFP@Activity()( currentNFP );
		selectComparator;
		compare.leftNFP -> currentNFP;
		compare.rightNFP -> request.updateNFP;
		compareNFP@Comparator( compare )( response );

		if ( response == 0 ) {
			println@Console( "\tUpdate rejected; cause: NFP not satisfying user preferences" )()
		}
	} ] { nullProcess }
}
