package ru.trackit.tracker2;

import android.app.Activity;
import android.app.Service;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Binder;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.os.Message;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.util.Log;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Calendar;
import java.util.Date;

public class TrackItService extends Service
        implements Runnable,LocationListener {


    LocationManager lm;
    String IMEI;
    DBAdaptor dbAdaptor;
    MainActivity context;
    Thread thread, looperThread;
    static Handler theHandler;
    int testcounter;
    boolean shouldStop=false;
    final String LOG_TAG = "TrackIt";
    public static final int STATE_INITIALIZING =0;
    public static final int STATE_UNAVALIBLE=1;
    public static final int STATE_WORKING =2;


    public static final int MSG_DEBUG_INFO=101;
    public static final int MSG_LOCATION=102;
    public static final int SMSG_REQUEST_DBDATA=103;
    public static final int MSG_LASTGPS=104;
    public static final int MSG_LASTSERVER=105;

    int State=0;

    //region onCreate Run etc
    @Override
    public void onCreate() {
        super.onCreate();
        IMEI = getIMEI();
        testcounter=0;
        thread=new Thread(this);
        thread.start();
        Deb("onCreate");
    }

    void Deb(Object obj){
        if (binder.mainActivity!=null){
            try {
                Message msg=new Message();
                msg.what=MSG_DEBUG_INFO;
                msg.obj=obj;
                binder.mainActivity.serviceHandler.sendMessage(msg);
            } catch (Exception e) {
                Log.e(LOG_TAG, "Deb TrackItService",e);
            }
        }
        Log.d(LOG_TAG, obj.toString());
    }

    @Override
    public void run() {

        try {
            dbAdaptor=new DBAdaptor(this);
            //db ready, server ready, Ready for a messages
            looperThread=new LooperThread();
            looperThread.start();

            Looper.prepare();
            while (true) {
                if (shouldStop)break;
                runGPS();
                runServerCommunication();
                testcounter++;
                Thread.sleep(1000);
            }
            dbAdaptor.close();
            stopSelf();
        }catch(Exception ex){
            ex.printStackTrace();
            Log.e(LOG_TAG, "TrackItService main run", ex);
        }
    }
//endregion

//region Server

    private static final String URL = "http://www.track-it.ru/gate-free.asmx";
    //private static final String URL = "http://192.168.43.15:2427/gate-free.asmx";
    void runServerCommunication(){
        Cursor cursor=null;
        TrackLocation loc=new TrackLocation();
        try {
            SQLiteDatabase database = dbAdaptor.getWritableDatabase();
            /*query(boolean distinct, String table, String[] columns,
            String selection, String[] selectionArgs, String groupBy,
            String having, String orderBy, String limit) */
            cursor = database.query(true, DBAdaptor.TABLE_GPSDATA, null,
                    DBAdaptor.KEY_STATE + "=" + TrackLocation.STATE_SAVED, null, null,
                    null, DBAdaptor.KEY_TIMESTAMP + " DESC", "1");

            if (cursor.moveToFirst()) {
                loc.FillByDB(cursor);
                cursor.close();
            }
            else
            {
                //Deb("Nothing to send");
                cursor.close();
                return;
            }



            ConnectivityManager connMgr = (ConnectivityManager)
                    getSystemService(Context.CONNECTIVITY_SERVICE);
            NetworkInfo networkInfo = connMgr.getActiveNetworkInfo();
            if (networkInfo != null && networkInfo.isConnected()) {
                // fetch data
            } else {
                // display error
                Deb("There is not of internet");
            }

            String result ="";
            InputStream is=null;
//gate-free.asmx/AddData?IMEI=string&Timestamp=string&Latitude=string&Longitude=string&Accuracy=string
            StringBuffer stringBuffer =  new StringBuffer(150);
            stringBuffer.append("/AddData?");
            stringBuffer.append("IMEI=");
            stringBuffer.append(IMEI);
            stringBuffer.append("&");

            stringBuffer.append("Timestamp=");
            stringBuffer.append(Integer.toString(loc.TimeStamp));
            stringBuffer.append("&");

            stringBuffer.append("Latitude=");
            stringBuffer.append(Double.toString(loc.Latitude));
            stringBuffer.append("&");

            stringBuffer.append("Longitude=");
            stringBuffer.append(Double.toString(loc.Longitude));
            stringBuffer.append("&");

            stringBuffer.append("Accuracy=");
            stringBuffer.append(Integer.toString(loc.Accuracy));

            try {
                java.net.URL url = new URL(URL +stringBuffer.toString());
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setReadTimeout(5000); // milliseconds
                conn.setConnectTimeout(7000); // milliseconds
                conn.setRequestMethod("GET");
                conn.setDoInput(true);
                // Starts the query
                conn.connect();
                int response = conn.getResponseCode();
                //Deb("The response is: " + response);
                if (response==200) {
                    is = conn.getInputStream();

                    // Convert the InputStream into a string
                    result = readIt(is, 200);
                }
            }catch (IOException ex) {
                Deb(ex.toString());
                Log.e(LOG_TAG, "ServerConnection", ex);
                // Makes sure that the InputStream is closed after the app is
                // finished using it.
            } finally {
                if (is != null) {
                    is.close();
                }
            }



            ContentValues contentValues = new ContentValues();

            Calendar c = Calendar.getInstance();
            lastConnectionDate=c.getTime();

            if (TextUtils.indexOf(result,"RESULT-OK")>=0){
                contentValues.put(DBAdaptor.KEY_STATE, TrackLocation.STATE_SENT);
                database.update(DBAdaptor.TABLE_GPSDATA, contentValues,
                        DBAdaptor.KEY_TIMESTAMP + "=" + loc.TimeStamp, null);
                loc.State=TrackLocation.STATE_SENT;
                sendLocationToView(loc);
                sendLastServerDatetoView();
            }else if (TextUtils.indexOf(result,"RESULT-REJECT")>=0) {
                contentValues.put(DBAdaptor.KEY_STATE, TrackLocation.STATE_REJECTED);
                database.update(DBAdaptor.TABLE_GPSDATA, contentValues,
                        DBAdaptor.KEY_TIMESTAMP + "=" + loc.TimeStamp, null);
                loc.State=TrackLocation.STATE_REJECTED;
                sendLocationToView(loc);
                sendLastServerDatetoView();
            }else if (TextUtils.indexOf(result,"RESULT-ERROR")>=0) {
                Deb("Server error: "+result);
            }else{
                Deb(result);
            }

        }
        catch (Exception e) {
            Deb(e.toString());
            Log.e(LOG_TAG, "ServerConnection", e);
        } finally {
            if (cursor != null && !cursor.isClosed())cursor.close();
        }
    }
    Date lastConnectionDate=null;
    void sendLastServerDatetoView(){
        Message msg=new Message();
        msg.what= MSG_LASTSERVER;
        msg.obj=lastConnectionDate;
        binder.mainActivity.serviceHandler.sendMessage(msg);
    }
    // Reads an InputStream and converts it to a String.
    public String readIt(InputStream stream, int len) throws IOException, UnsupportedEncodingException {
        Reader reader = null;
        reader = new InputStreamReader(stream, "UTF-8");//
        char[] buffer = new char[len];
        reader.read(buffer);

        return new String(buffer);
    }
//endregion


    //region GPS
    //интервал замера
    private int measureInterval=60;
    private boolean requestGPSDataFromDB=false;
    Location lastLocation=null;
    Location preveiusLocation=null;
    void runGPS(){

        if (State == STATE_INITIALIZING){
            lm = (LocationManager)this.getSystemService(Activity.LOCATION_SERVICE);
            lm.requestLocationUpdates(LocationManager.GPS_PROVIDER,10000,7,this);
            if (lm.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
                State = STATE_WORKING;
            } else {
                State = STATE_UNAVALIBLE;
            }
            retrainGPSData();
        }
        if (State==STATE_UNAVALIBLE){
            if (lm.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
                State = STATE_WORKING;
            }
        }
        if (State==STATE_WORKING){
            //lm.requestSingleUpdate(LocationManager.GPS_PROVIDER,this,Looper.myLooper());
            if (!lm.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
                State = STATE_UNAVALIBLE;
                return;
            }
            Location location = lm.getLastKnownLocation(LocationManager.GPS_PROVIDER);
            //при включение при первом проходе
            if (lastLocation==null && location!=null){
                lastLocation=location;
                preveiusLocation=location;
                TrackLocation loc=new TrackLocation(lastLocation);
                //save to db
                saveLocationToDB(loc);
                sendLocationToView(loc);
                Calendar c = Calendar.getInstance();
                lastGPSDate=c.getTime();
                sendLastGPSDatetoView();
            }
            if (lastLocation!=null) {
                //обновляем последние известные данные
                if (location.getTime()>lastLocation.getTime()){
                    lastLocation=location;
                }

                if (!isEqualLocations(lastLocation,preveiusLocation)){
                    Deb("New location " + lastLocation.toString());
                    long timespan = getTimeSpan(lastLocation,preveiusLocation);
                    Calendar c = Calendar.getInstance();
                    lastGPSDate=c.getTime();
                    sendLastGPSDatetoView();
                    if (timespan>=measureInterval){
                        TrackLocation loc=new TrackLocation(lastLocation);
                        //save to db
                        saveLocationToDB(loc);
                        //update view
                        sendLocationToView(loc);
                        //update previous last location
                        preveiusLocation=lastLocation;
                    }
                }


            }
        }

    }
//endregion


    public void onMessage(android.os.Message msg) {
        switch (msg.what){
            case TrackItService.SMSG_REQUEST_DBDATA:
                retrainGPSData();
                break;
        }
    }
    void retrainGPSData(){
        sendLastGPSDatetoView();
        sendLastServerDatetoView();
        Cursor cursor=null;
        try {
            SQLiteDatabase database = dbAdaptor.getReadableDatabase();
            /*query(boolean distinct, String table, String[] columns,
            String selection, String[] selectionArgs, String groupBy,
            String having, String orderBy, String limit) */
            cursor = database.query(true, DBAdaptor.TABLE_GPSDATA, null,
                    null, null, null,
                    null, DBAdaptor.KEY_TIMESTAMP + " DESC", "100");

            if (cursor.moveToFirst()) {
                int timestampIndex = cursor.getColumnIndex(DBAdaptor.KEY_TIMESTAMP);
                int latitudeIndex = cursor.getColumnIndex(DBAdaptor.KEY_LATITUDE);
                int longitudeIndex = cursor.getColumnIndex(DBAdaptor.KEY_LONGITUDE);
                int stateIndex = cursor.getColumnIndex(DBAdaptor.KEY_STATE);
                do {
                    TrackLocation tl=new TrackLocation();
                    tl.TimeStamp=cursor.getInt(timestampIndex);
                    tl.Latitude=cursor.getDouble(latitudeIndex);
                    tl.Longitude=cursor.getDouble(longitudeIndex);
                    tl.State=cursor.getInt(stateIndex);
                    sendLocationToView(tl);
                } while (cursor.moveToNext());
            }
            else
            {
                Deb("No rows");
            }

            cursor.close();
        } catch (Exception e) {
            Deb(e.toString());
            Log.e(LOG_TAG, "retrain gps data", e);
        } finally {
            if (cursor != null && !cursor.isClosed())cursor.close();
        }
    }
    void sendLocationToView(TrackLocation loc){
        Message msg=new Message();
        msg.what= MSG_LOCATION;
        msg.obj=loc;
        try {
            binder.mainActivity.serviceHandler.sendMessage(msg);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    Date lastGPSDate=null;
    void sendLastGPSDatetoView(){
        Message msg=new Message();
        msg.what= MSG_LASTGPS;
        msg.obj=lastGPSDate;
        try {
            binder.mainActivity.serviceHandler.sendMessage(msg);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    void saveLocationToDB(TrackLocation loc){
        SQLiteDatabase database = dbAdaptor.getWritableDatabase();
        ContentValues contentValues = new ContentValues();
        contentValues.put(DBAdaptor.KEY_TIMESTAMP, loc.TimeStamp);
        contentValues.put(DBAdaptor.KEY_ACCURACY, loc.Accuracy);
        contentValues.put(DBAdaptor.KEY_LATITUDE, loc.Latitude);
        contentValues.put(DBAdaptor.KEY_LONGITUDE, loc.Longitude);
        contentValues.put(DBAdaptor.KEY_STATE, TrackLocation.STATE_SAVED);

        database.insert(DBAdaptor.TABLE_GPSDATA, null, contentValues);
        loc.State=TrackLocation.STATE_SAVED;
    }







//region LocationListener Interface

    @Override
    public void onLocationChanged(Location location) {

    }

    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {

    }

    @Override
    public void onProviderEnabled(String provider) {

    }

    @Override
    public void onProviderDisabled(String provider) {

    }
    public boolean isEqualLocations(Location l1, Location l2){
        return l1.getTime()==l2.getTime();
    }

//endregion



    //Timestamp in seconds
    public long getTimeStamp(long time){
        return time/1000;
    }
    //Timespan in seconds
    public long getTimeSpan(Location l1, Location l2){
        if (l1.getTime()>l2.getTime())return getTimeStamp(l1.getTime()-l2.getTime());
        if (l2.getTime()>l1.getTime())return getTimeStamp(l2.getTime()-l1.getTime());
        return 0;
    }

    String getIMEI() {
        /*return "861187030982469";*/

        String identifier = null;
        android.telephony.TelephonyManager tm = (android.telephony.TelephonyManager) this.getSystemService(android.content.Context.TELEPHONY_SERVICE);
        if (tm != null)
            identifier = tm.getDeviceId();

        if (TextUtils.isEmpty(identifier))
            identifier = android.provider.Settings.Secure.getString(this.getContentResolver(), android.provider.Settings.Secure.ANDROID_ID);
        return identifier;
    }

    public void stopService(){
        shouldStop=true;
    }
    @Nullable
    @Override

    public IBinder onBind(Intent intent) {

        return binder;
    }


    TrackItBinder binder=new TrackItBinder();


    class TrackItBinder extends Binder {
        TrackItService getService() {
            return TrackItService.this;
        }
        MainActivity mainActivity;
        void setMainActivity(MainActivity activity){
            mainActivity=activity;
        }
    }
    //класс для приема сообщений от Активити
    class LooperThread extends Thread {
        public void run() {
            Looper.prepare();
            theHandler=new Handler(){
                @Override
                public void handleMessage(Message msg) {
                    onMessage(msg);
                }
            };
            Looper.loop();
        }
    }
    class TrackLocation{
        public static final int STATE_NEW=201;
        public static final int STATE_SAVED=202;
        public static final int STATE_SENT=204;
        public static final int STATE_REJECTED=205;
        public Location location;
        public int State = STATE_NEW;
        public double Latitude = 0.0;
        public double Longitude = 0.0;
        public int Accuracy = 0;
        public int TimeStamp=0;
        public TrackLocation(){}
        public TrackLocation(Location location){
            State=STATE_NEW;
            this.Latitude=location.getLatitude();
            this.Longitude=location.getLongitude();
            this.Accuracy=(int)location.getAccuracy();
            this.TimeStamp=(int)(location.getTime()/1000);
        }
        public void FillByDB(Cursor cursor){
            int timestampIndex = cursor.getColumnIndex(DBAdaptor.KEY_TIMESTAMP);
            int latitudeIndex = cursor.getColumnIndex(DBAdaptor.KEY_LATITUDE);
            int longitudeIndex = cursor.getColumnIndex(DBAdaptor.KEY_LONGITUDE);
            int stateIndex = cursor.getColumnIndex(DBAdaptor.KEY_STATE);
            this.TimeStamp=cursor.getInt(timestampIndex);
            this.Latitude = cursor.getDouble(latitudeIndex);
            this.Longitude=cursor.getDouble(longitudeIndex);
            this.State = cursor.getInt(stateIndex);
        }
    }
    class DBAdaptor extends SQLiteOpenHelper
    {


        public static final int DATABASE_VERSION = 2;
        public static final String DATABASE_NAME = "TrackItDB";
        public static final String TABLE_GPSDATA = "gpsdata";

        public static final String KEY_ID = "_id";
        public static final String KEY_TIMESTAMP = "timestamp";
        public static final String KEY_STATE = "state";
        public static final String KEY_ACCURACY = "accuracy";
        public static final String KEY_LATITUDE = "latitude";
        public static final String KEY_LONGITUDE = "longitude";

        public DBAdaptor(Context context) {
            super(context, DATABASE_NAME, null, DATABASE_VERSION);
        }



        /**
         * Called when the database is created for the first time. This is where the
         * creation of tables and the initial population of the tables should happen.
         *
         * @param db The database.
         */
        @Override
        public void onCreate(SQLiteDatabase db) {
            db.execSQL("create table " + TABLE_GPSDATA + " ("
                    + KEY_ID + " integer primary key, "
                    + KEY_TIMESTAMP + " integer, "
                    + KEY_STATE + " integer, "
                    + KEY_ACCURACY + " integer, "
                    + KEY_LATITUDE + " real, "
                    + KEY_LONGITUDE + " real"
                    + ")");
        }

        /**
         * Called when the database needs to be upgraded. The implementation
         * should use this method to drop tables, add tables, or do anything else it
         * needs to upgrade to the new schema version.
         * <p/>
         * <p>
         * The SQLite ALTER TABLE documentation can be found
         * <a href="http://sqlite.org/lang_altertable.html">here</a>. If you add new columns
         * you can use ALTER TABLE to insert them into a live table. If you rename or remove columns
         * you can use ALTER TABLE to rename the old table, then create the new table and then
         * populate the new table with the contents of the old table.
         * </p><p>
         * This method executes within a transaction.  If an exception is thrown, all changes
         * will automatically be rolled back.
         * </p>
         *
         * @param db         The database.
         * @param oldVersion The old database version.
         * @param newVersion The new database version.
         */
        @Override
        public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
            //db.execSQL("drop table if exists " + TABLE_CONTACTS);

            //onCreate(db);
        }
    }
}
