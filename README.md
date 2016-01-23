Icersplicer
==========

[![Gem Version](https://badge.fury.io/rb/icersplicer.svg)](https://badge.fury.io/rb/icersplicer)

![Icersplicer Nova](https://raw.githubusercontent.com/puppetpies/icersplicer/master/Icersplicer-nova.png)

Text file manipulation with the Ruby progamming language.

A tool for people who are fans of UNIX tools like cat / head / tail but realize
that they don't do certain things like offsets the ability to skip lines etc..

Thats where icersplicer comes in.

It also features fun keyword highlighting randomization and static keyword colours!

Checkout the keywords.ice in examples and copy it in your home folder under the .icersplicer directory

![Icesplicer](https://raw.githubusercontent.com/puppetpies/icersplicer/master/icersplicer.jpg)

`
Example usage:

> [brian@orville icersplicer]$ bin/icersplicer -f /home/brian/Downloads/voc_dump.sql  -g '(^\);)'
> Ln: 27: );
> Ln: 8233: );
> Ln: 10596: );
> Ln: 11544: );
> Ln: 15340: );
> Ln: 18167: );
> Ln: 22649: );
> Ln: 26840: );
> Inputfile lines: Filename: /home/brian/Downloads/voc_dump.sql Total Line Count: 29335
> Start: 2016-01-23 17:17:18 +0000 Finish: 2016-01-23 17:17:19 +0000 Total time: 1.05
 
[brian@orville icersplicer]$ bin/icersplicer -f /home/brian/Downloads/voc_dump.sql  -g 'CREATE TABLE'
Ln: 4: CREATE TABLE "voyages" (
Ln: 8222: CREATE TABLE "craftsmen" (
Ln: 10585: CREATE TABLE "impotenten" (
Ln: 11537: CREATE TABLE "invoices" (
Ln: 15329: CREATE TABLE "passengers" (
Ln: 18156: CREATE TABLE "seafarers" (
Ln: 22638: CREATE TABLE "soldiers" (
Ln: 26829: CREATE TABLE "total" (
Inputfile lines: Filename: /home/brian/Downloads/voc_dump.sql Total Line Count: 29335
Start: 2016-01-23 17:17:22 +0000 Finish: 2016-01-23 17:17:23 +0000 Total time: 1.02
 
[brian@orville icersplicer]$ bin/icersplicer -f /home/brian/Downloads/voc_dump.sql -s 28-8221,8233-10584,10597-11537 --linelimit 11537
Ln: 0: START TRANSACTION;
Ln: 1: 
Ln: 2: SET SCHEMA "voc";
Ln: 3: 
Ln: 4: CREATE TABLE "voyages" (
Ln: 5: 	"number"            integer	NOT NULL,
Ln: 6: 	"number_sup"        char(1)	NOT NULL,
Ln: 7: 	"trip"              integer,
Ln: 8: 	"trip_sup"          char(1),
Ln: 9: 	"boatname"          varchar(50),
Ln: 10: 	"master"            varchar(50),
Ln: 11: 	"tonnage"           integer,
Ln: 12: 	"type_of_boat"      varchar(30),
Ln: 13: 	"built"             varchar(15),
Ln: 14: 	"bought"            varchar(15),
Ln: 15: 	"hired"             varchar(15),
Ln: 16: 	"yard"              char(1),
Ln: 17: 	"chamber"           char(1),
Ln: 18: 	"departure_date"    date,
Ln: 19: 	"departure_harbour" varchar(30),
Ln: 20: 	"cape_arrival"      date,
Ln: 21: 	"cape_departure"    date,
Ln: 22: 	"cape_call"         boolean,
Ln: 23: 	"arrival_date"      date,
Ln: 24: 	"arrival_harbour"   varchar(30),
Ln: 25: 	"next_voyage"       integer,
Ln: 26: 	"particulars"       varchar(1285)
Ln: 27: );
Ln: 8222: CREATE TABLE "craftsmen" (
Ln: 8223: 	"number"               integer	NOT NULL,
Ln: 8224: 	"number_sup"           char(1)	NOT NULL,
Ln: 8225: 	"trip"                 integer,
Ln: 8226: 	"trip_sup"             char(1),
Ln: 8227: 	"onboard_at_departure" integer,
Ln: 8228: 	"death_at_cape"        integer,
Ln: 8229: 	"left_at_cape"         integer,
Ln: 8230: 	"onboard_at_cape"      integer,
Ln: 8231: 	"death_during_voyage"  integer,
Ln: 8232: 	"onboard_at_arrival"   integer
Ln: 10585: CREATE TABLE "impotenten" (
Ln: 10586: 	"number"               integer	NOT NULL,
Ln: 10587: 	"number_sup"           char(1)	NOT NULL,
Ln: 10588: 	"trip"                 integer,
Ln: 10589: 	"trip_sup"             char(1),
Ln: 10590: 	"onboard_at_departure" integer,
Ln: 10591: 	"death_at_cape"        integer,
Ln: 10592: 	"left_at_cape"         integer,
Ln: 10593: 	"onboard_at_cape"      integer,
Ln: 10594: 	"death_during_voyage"  integer,
Ln: 10595: 	"onboard_at_arrival"   integer
Ln: 10596: );
Inputfile lines: Filename: /home/brian/Downloads/voc_dump.sql Total Line Count: 29335
Start: 2016-01-23 17:17:32 +0000 Finish: 2016-01-23 17:17:33 +0000 Total time: 1.47
 
Have fun !
`
