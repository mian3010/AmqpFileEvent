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
	response.trainNumber = 81
}

define onEvaluateConstraint
{
	if ( request.trainNumber == 73 ) {
		response = 1
	} else {
		response = 0
	}
}

define dataInit
{
	with( rule ) {
		.activityName = "TakeTrain";
		.activityFilename = "TakeTrainCode.ol";
		.checkVariableNames.name[0] = "trainNumber";
		.checkVariableNames.name[1] = "from";
		.checkVariableNames.name[2] = "to";
		.executionVariableNames.name[0] = "trainNumber";
		.executionVariableNames.name[1] = "from";
		.executionVariableNames.name[2] = "to";
		.compulsory = 0;
		.nfp.cost = 62; // Euros
		.nfp.time = 103 // Minutes
	}
}