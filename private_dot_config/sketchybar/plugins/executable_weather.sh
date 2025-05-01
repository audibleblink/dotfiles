sketchybar --set $NAME \
  label="Loading..." \
  icon.color=0xff5edaff

# fetch weather data
LOCATION="xna"
WEATHER_JSON=$(curl -s "https://wttr.in/$LOCATION?0&format=j1")

# Fallback if empty
if [ -z $WEATHER_JSON ]; then
  sketchybar --set $NAME label="$LOCATION"
  return
fi

TEMPERATURE=$(echo $WEATHER_JSON | jq -r '.current_condition[0].temp_F')
WEATHER_DESCRIPTION=$(echo $WEATHER_JSON | jq -r '.current_condition[0].weatherDesc[0].value')

sketchybar --set $NAME \
  label="${TEMPERATURE}° • ${WEATHER_DESCRIPTION}"
