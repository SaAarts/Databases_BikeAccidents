/*
create comman for all tables based on our ER diagram.
it differs from the ER by connecting Accident and Location (ER did not list the column, but noted the relation)
Changed the name of the junction table of Bicycle and Cyclist from BicycleCyclist to BicycleOwnership
*/


-- MockdataGood.AccidentType definition
CREATE TABLE `AccidentType` (
  `accdentTypeID` int(11) NOT NULL,
  `type` varchar(100) DEFAULT NULL,
  `rain_effect_score` int(10) DEFAULT NULL,
  PRIMARY KEY (`accdentTypeID`)
);

-- MockdataGood.Bicycle definition
CREATE TABLE `Bicycle` (
  `serial_num` varchar(12) NOT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `ebike` tinyint(1) DEFAULT NULL,
  `fatbike` tinyint(1) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  PRIMARY KEY (`serial_num`)
);
  
-- MockdataGood.Cyclist definition
CREATE TABLE `Cyclist` (
  `BSN` int(11) NOT NULL,
  `age` int(11) DEFAULT NULL,
  `helmet_usually` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`BSN`)
);

-- MockdataGood.DownfallType definition
CREATE TABLE `DownfallType` (
  `downfallTypeID` int(11) NOT NULL,
  `type` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`downfallTypeID`)
);

-- MockdataGood.ReasonType definition
CREATE TABLE `ReasonType` (
  `reasonTypeID` int(11) NOT NULL,
  `type` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`reasonTypeID`)
);

-- MockdataGood.RoadType definition
CREATE TABLE `RoadType` (
  `roadTypeID` int(11) NOT NULL,
  `type` varchar(100) DEFAULT NULL,
  `rain_effect_score` int(10) DEFAULT NULL,
  PRIMARY KEY (`roadTypeID`)
);

-- MockdataGood.BicycleOwnership definition
CREATE TABLE `BicycleOwnership` (
  `bicycleCyclistID` int(11) NOT NULL AUTO_INCREMENT,
  `cyclist` int(11) DEFAULT NULL,
  `bike` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`bicycleCyclistID`),
  KEY `BicycleOwnership_Cyclist_FK` (`cyclist`),
  KEY `BicycleOwnership_Bicycle_FK` (`bike`),
  CONSTRAINT `BicycleOwnership_Bicycle_FK` FOREIGN KEY (`bike`) REFERENCES `Bicycle` (`serial_num`),
  CONSTRAINT `BicycleOwnership_Cyclist_FK` FOREIGN KEY (`cyclist`) REFERENCES `Cyclist` (`BSN`)
);

-- MockdataGood.Location definition
CREATE TABLE `Location` (
  `placeID` int(11) NOT NULL AUTO_INCREMENT,
  `city` varchar(25) DEFAULT NULL,
  `street` varchar(100) DEFAULT NULL,
  `road_quality_score` int(10) DEFAULT NULL,
  `road_type` int(11) DEFAULT NULL,
  PRIMARY KEY (`placeID`),
  KEY `Location_RoadType_FK` (`road_type`),
  CONSTRAINT `Location_RoadType_FK` FOREIGN KEY (`road_type`) REFERENCES `RoadType` (`roadTypeID`)
);

-- MockdataGood.Accident definition
CREATE TABLE `Accident` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) DEFAULT NULL,
  `time` date DEFAULT NULL,
  `reason` int(11) DEFAULT NULL,
  `downfall` int(11) DEFAULT NULL,
  `location` int(11) DEFAULT NULL,
  `temperature` int(11) DEFAULT NULL,
  `road_wet` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `Accident_AccidentType_FK` (`type`),
  KEY `Accident_ReasonType_FK` (`reason`),
  KEY `Accident_DownfallType_FK` (`downfall`),
  KEY `Accident_Location_FK` (`location`),
  CONSTRAINT `Accident_AccidentType_FK` FOREIGN KEY (`type`) REFERENCES `AccidentType` (`accdentTypeID`),
  CONSTRAINT `Accident_DownfallType_FK` FOREIGN KEY (`downfall`) REFERENCES `DownfallType` (`downfallTypeID`),
  CONSTRAINT `Accident_Location_FK` FOREIGN KEY (`location`) REFERENCES `Location` (`placeID`),
  CONSTRAINT `Accident_ReasonType_FK` FOREIGN KEY (`reason`) REFERENCES `ReasonType` (`reasonTypeID`)
);

-- MockdataGood.CyclistAccident definition
CREATE TABLE `CyclistAccident` (
  `cyclistAccidentID` int(11) NOT NULL AUTO_INCREMENT,
  `cyclist` int(11) DEFAULT NULL,
  `accident` int(11) DEFAULT NULL,
  `serial_num` varchar(12) DEFAULT NULL,
  `lethal` tinyint(1) DEFAULT NULL,
  `at_fault` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`cyclistAccidentID`),
  KEY `CyclistAccident_Cyclist_FK` (`cyclist`),
  KEY `CyclistAccident_Accident_FK` (`accident`),
  KEY `CyclistAccident_Bicycle_FK` (`serial_num`),
  CONSTRAINT `CyclistAccident_Accident_FK` FOREIGN KEY (`accident`) REFERENCES `Accident` (`ID`),
  CONSTRAINT `CyclistAccident_Bicycle_FK` FOREIGN KEY (`serial_num`) REFERENCES `Bicycle` (`serial_num`),
  CONSTRAINT `CyclistAccident_Cyclist_FK` FOREIGN KEY (`cyclist`) REFERENCES `Cyclist` (`BSN`)
);
