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

include "../../AbstractRule.iol"

define onGetStateUpdate
{
	response.busNumber = -1
}

define onEvaluateConstraint
{
	if ( request.busNumber > -1 ) {
		response = 1
	} else {
		response = 0
	}
}

define dataInit
{
	with( rule ) {
		.activityName = "TakeBus";
		.activityFilename = "TakeTaxiCode.ol";
		.checkVariableNames.name[0] = "busNumber";
		.checkVariableNames.name[1] = "busFrom";
		.checkVariableNames.name[2] = "busTo";
		.executionVariableNames.name[0] = "busFrom";
		.executionVariableNames.name[1] = "busTo";
		.compulsory = 0;
		.nfp.cost = 20; // Euros
		.nfp.time = 10 // Minutes
	}
}