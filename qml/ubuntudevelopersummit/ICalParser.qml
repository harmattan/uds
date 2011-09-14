import QtQuick 1.1
import "script.js" as Script

QtObject {
    property ICal ical: ICal {}

    function parse(icalString) {
        console.debug("epic")

        ical.version = __getValue('VERSION', icalString);
        ical.productId  = __getValue('PRODID', icalString);

        console.debug("hai")

        var reg = /BEGIN:VEVENT(\r?\n[^B].*)+/g;
        var matches = icalString.match(reg);
        if (matches) {
            for (var i = 0; i < matches.length; ++i) {
                console.log(matches[i]);
                parseEvent(matches[i]);
            }
        }
        console.debug('parsed');
        ical.events = Script.getList()
        console.debug(ical.version)
        console.debug(ical.events.length)
    }

    function __stringToDate(string) {
        var DURATION = /^(\d\d\d\d)(\d\d)(\d\d)T(\d\d)(\d\d)(\d\d)(Z*)/
        //                 Y Y Y Y   M M   D D    h h   m m   s s
        var matches = DURATION.exec(string)
        if (!matches[7]) { // No Z -> not UTC
            console.debug("NO UTC DATE!!!")
            Qt.quit()
        }
        return new Date(matches[1], matches[2], matches[3], matches[4], matches[5], matches[6])
    }

    function parseEvent(veventString) {
        var eventComponent = Qt.createComponent("Event.qml")
        var event = eventComponent.createObject(this)

        event.uid = __getValue('UID', veventString)

        event.start = __stringToDate(__getValue('DTSTART', veventString))
        event.end   = __stringToDate(__getValue('DTEND', veventString))

        event.categories = __getValue('CATEGORIES', veventString,true)
        event.summary = __getValue('SUMMARY',veventString)
        event.location = __getValue('LOCATION', veventString)
        event.description = __getValue('DESCRIPTION', veventString)
        event.x_type = __getValue('X-TYPE', veventString)
        event.x_roomname = __getValue('X-ROOMNAME', veventString)

        Script.addItem(event)
    }

    function __getValue(propName, txt, multiple){
        if(multiple){
            eval('var matches=txt.match(/\\n'+propName+'[^:]*/g)');
            var props=[];
            if(matches){
                for(var l=0;l<matches.length;l++){
                    //on enleve les parametres
                    matches[l]=matches[l].replace(/;.*/,'');
                    props[props.length] = __getValue(matches[l],txt);
                }
                return props;
            }
        }else{
            var reg=new RegExp('('+propName+')(;[^=]*=[^;:\n]*)*:([^\n]*)','g');
            var matches=reg.exec(txt);
            if (matches) { //on a trouvé la propriété cherchée
                var valeur=RegExp.$3;
                var tab_params;
                if(RegExp.$2.length>0){ //il y a des paramètres associés
                    var params=RegExp.$2.substr(1).split(';');
                    var pair;var code='';
                    for(var k=0;k<params.length;k++){
                        pair=params[k].split('=');
                        if(!pair[1]) pair[1]=pair[0];
                        code+=pair[0].replace(/-/,'')+' : "'+pair[1]+'", ';
                    }
                    eval('tab_params=( { '+code.substr(0,code.length-2)+' } );');
                }
                //console.log(propName+' '+valeur+'\n'+toJsonString(tab_params));
                return valeur
            }else{
                return null;
            }
        }
    }
}
