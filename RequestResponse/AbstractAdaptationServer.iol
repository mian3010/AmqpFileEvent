/***************************************************************************
 *   Copyright (C) 2009-2010 by Fabrizio Montesi <famontesi@gmail.com>     *
 *   Copyright (C) 2009-2010 by Ivan Lanese <lanese@cs.unibo.it>           *
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
include "AdaptationManager.iol"
include "locations.iol"
include "runtime.iol"
include "console.iol"
include "types.iol"
include "Rule.iol"
include "State.iol"
include "Matcher.iol"
include "file.iol"
include "ActivityManager.iol"

execution { concurrent }

inputPort AdaptationServerInput {
Location: Location_AdaptationServer
Protocol: sodep
Interfaces: AdaptationServerInterface
}

outputPort AdaptationManager {
Location: Location_AdaptationManager
Protocol: sodep
Interfaces: AdaptationManagerInterface, StateInterface
}

outputPort Rule {
Interfaces: RuleInterface
}

outputPort State {
Protocol: sodep
Interfaces: StateInterface
}

outputPort ActivityManager {
Protocol: sodep
Interfaces: ActivityManagerInterface
}

outputPort Matcher {
Interfaces: MatcherInterface
}

embedded {
Jolie:
	"Matcher.ol" in Matcher
}

init
{
	rules -> global.rules;
	registerAdaptationServer@AdaptationManager( global.inputPorts.AdaptationServerInput )();
	getServiceDirectory@File()( serviceDirectory );
	getFileSeparator@File()( fileSeparator );
	rulesDirectory = serviceDirectory + fileSeparator + "rules" + fileSeparator;
	f.directory = rulesDirectory;
	f.regex = ".*Rule\\.ol";
	list@File( f )( list );
	s.type = "Jolie";
	for( i = 0, i < #list.result, i++ ) {
		println@Console( "Loading rule " + list.result[i] )();
		s.filepath = rulesDirectory + list.result[i];
		loadEmbeddedService@Runtime( s )( Rule.location );
		getDescription@Rule()( rules[i] );
		rules[i].location = Rule.location;
		rules[i].filename = list.result[i]
	};
	undef( f )
}

define checkSubSet
{
	found = 1;
	for( k = 0, k < #left && found == 1, k++ ) {
		found = 0;
		for( j = 0, j < #right && found == 0, j++ ) {
			if ( left[k] == right[j] ) {
				found = 1
			}
		}
	};
	result = found
}

define checkRules
{
	getVariableNames@AdaptationManager()( envVariableNames );
	rule -> rules[i];
	for( i = 0, i < #rules, i++ ) {
		println@Console( "Checking rule " + rule.filename + " for activity " + request.activityName )();
		Rule.location = rule.location;
		matchRequest.activityName[0] = request.activityName;
		matchRequest.activityName[1] = rule.activityName;
		match@Matcher( matchRequest )( matches );
		if ( matches ) {
			println@Console( "\tDescriptions MATCH positive" )();
			left -> rule.executionVariableNames.name;
			right -> request.variableNames.name;
			checkSubSet;
			if ( result ) {
				println@Console( "\tExecution variables for new activity available" )();
				left -> rule.checkVariableNames.name;
				undef( right );
				found = 1;
				for( k = 0, k < #left && found == 1, k++ ) {
					right -> request.variableNames.name;
					found = 0;
					State.location = request.client;
					for( j = 0, j < #right && found == 0, j++ ) {
						if ( left[k] == right[j] ) {
							found = 1;
							get@State( left[k] )( eval.(left[k]) )
						}
					};
					right -> envVariableNames.name;
					State.location = AdaptationManager.location;
					for( j = 0, j < #right && found == 0, j++ ) {
						if ( left[k] == right[j] ) {
							found = 1;
							get@State( left[k] )( eval.(left[k]) )
						}
					}
				};
				if ( found ) {
					println@Console( "\tVariables for constraint evaluation available" )();
					evaluateConstraint@Rule( eval )( result );
					if ( result ) {
						println@Console( "\tConstraint satisfied" )();
						if ( rule.compulsory ) {
							println@Console( "\tCompulsory rule, skipping NFP check" )();
							send = 1
						} else {
							ActivityManager.location = request.client;
							checkRequest.activityName = request.activityName;
							checkRequest.updateNFP -> rule.nfp;
							println@Console( "\tNot compulsory rule, asking client for user preferences checking..." )();
							checkUpdateNFP@ActivityManager( checkRequest )( send );
							if ( !send ) {
								println@Console( "\tUser preferences not met, skipping rule" )()
							}
						};
						if ( send ) {
							println@Console( "\tRule applies, sending new code" )();
							getStateUpdate@Rule()( stateUpdate );
							State.location = request.client;
							foreach( varName : stateUpdate ) {
								var = varName;
								var.value = stateUpdate.(varName);
								set@State( var )()
							};
							f.filename = rulesDirectory + rules[i].activityFilename;
							readFile@File( f )( response )
						}
					} else {
						println@Console( "\tConstraint not satisfied, skipping rule" )()
					}
				} else {
					println@Console( "\tVariables for constraint evaluation not available, skipping rule" )()
				}
			} else {
				println@Console( "\tExecution variables for new activity not available, skipping rule" )()
			}
		} else {
			println@Console( "\tDescriptions MATCH not positive, skipping rule" )()
		}
	}
}

main
{
	checkForUpdate( request )( response ) {
		checkRules
	}
}
