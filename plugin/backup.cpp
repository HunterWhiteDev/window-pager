void PagerItem::handlePassedData(std::string data) {
  /*
   // Parse raw data
   cJSON *json = cJSON_Parse(&data[0]);
   // get windowData array in "data" field
   cJSON *windowData = cJSON_GetObjectItem(json, "data");

   // Store the current iteration
   cJSON *window;

   cJSON_ArrayForEach(window, windowData) {
     cJSON *internalId = cJSON_GetObjectItem(window, "internalId");
     cJSON *minimized = cJSON_GetObjectItem(window, "minimized");

     string internalIdString = internalId->valuestring;
     bool minimizedBool = cJSON_IsTrue(minimized);

     if (!minimizedBool) {
       qDebug() << "Window is not minimized";
     }
   }
   */
}
