package ru.trackit.tracker2;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.view.View;
import android.support.v4.view.GravityCompat;
import android.support.v7.app.ActionBarDrawerToggle;
import android.view.MenuItem;
import android.support.design.widget.NavigationView;
import android.support.v4.widget.DrawerLayout;

import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.content.ComponentName;
import android.content.Intent;
import android.content.ServiceConnection;
import android.location.Location;
import android.location.LocationListener;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.ArrayMap;
import android.util.Log;
import android.util.SparseArray;
import android.util.SparseIntArray;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;


import java.text.DateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.SortedMap;
import java.util.TimeZone;





public class MainActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {



    private TextView tvIMEI;
    private TextView tvGPS;
    private TextView tvConnection;
    private TrackItService glManager;
    private TextView debugText;
    private ScrollView tableScroll;
    private TableLayout table;

    public Handler glHandler;

    Intent serviceIntent;
    ServiceConnection serviceConnection;
    TrackItService service;
    boolean serviceBound = false;
    static Handler serviceHandler;
    //Dictionary of location table view: timestamp, TrackLocation
    SparseArray locationTable;

    final String LOG_TAG = "TrackIt";



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        FloatingActionButton fab = findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
            }
        });
        DrawerLayout drawer = findViewById(R.id.drawer_layout);
        NavigationView navigationView = findViewById(R.id.nav_view);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.addDrawerListener(toggle);
        toggle.syncState();
        navigationView.setNavigationItemSelectedListener(this);

        // Here, thisActivity is the current activity
        if (ContextCompat.checkSelfPermission(this,
                Manifest.permission.INTERNET)
                != PackageManager.PERMISSION_GRANTED) {

                // No explanation needed; request the permission
                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.INTERNET},
                        1);
                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.READ_PHONE_STATE},
                        2);
                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                        3);
                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.ACCESS_NETWORK_STATE},
                        4);
        } else {
            // Permission has already been granted
        }




        tvIMEI = (TextView) findViewById(R.id.textViewIMEI);
        tvGPS = (TextView) findViewById(R.id.textViewGPS);
        tvConnection = (TextView) findViewById(R.id.textViewLastConnection);
        debugText = (TextView) findViewById(R.id.debugText);
        table=(TableLayout)findViewById(R.id.gpsTable);
        locationTable = new SparseArray<TrackItService.TrackLocation>();
        tableScroll = (ScrollView)findViewById(R.id.gpsTableScroll);




        serviceIntent = new Intent(this, TrackItService.class);
        serviceConnection = new ServiceConnection() {
            public void onServiceConnected(ComponentName name, IBinder binder) {
                Deb(LOG_TAG, "MainActivity onServiceConnected");
                TrackItService.TrackItBinder b=(TrackItService.TrackItBinder) binder;
                service = b.getService();
                b.setMainActivity(MainActivity.this);
                serviceBound = true;
                service.theHandler.sendEmptyMessage(TrackItService.SMSG_REQUEST_DBDATA);
                //abcdef0123456789 or 01234567123456798
                tvIMEI.setText(service.IMEI);
            }

            public void onServiceDisconnected(ComponentName name) {
                Deb(LOG_TAG, "MainActivity onServiceDisconnected");
                serviceBound = false;
            }
        };

        serviceHandler=new Handler(){
            @Override
            public void handleMessage(Message msg) {
                onServiceMessage(msg);
            }
        };

        Deb("OnCreate");
        if(!serviceBound)startService(serviceIntent);
    }

    @Override
    public void onBackPressed() {
        DrawerLayout drawer = findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        // Handle navigation view item clicks here.
        int id = item.getItemId();

        if (id == R.id.nav_home) {
            // Handle the camera action
        } else if (id == R.id.nav_gallery) {

        } else if (id == R.id.nav_slideshow) {

        } else if (id == R.id.nav_tools) {

        } else if (id == R.id.nav_share) {

        } else if (id == R.id.nav_send) {

        }

        DrawerLayout drawer = findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }






    public void onServiceMessage(android.os.Message msg) {
        switch (msg.what){
            case TrackItService.MSG_DEBUG_INFO:
                Deb(msg.obj);
                break;
            case TrackItService.MSG_LOCATION:
                ProcessLocation((TrackItService.TrackLocation) msg.obj);
                break;
            case TrackItService.MSG_LASTGPS:
                setTextLastGPS((Date) msg.obj);
                break;
            case TrackItService.MSG_LASTSERVER:
                setTextLastServerConnection((Date) msg.obj);
                break;
        }
    }

    int calculateSeconds(Date date){
        if (date == null) return -1;
        int now = (int)(new Date().getTime()/1000);
        int timestamp = (int)(date.getTime()/1000);
        if(now>=timestamp){
            return now-timestamp;
        }
        return -1;
    }
    String getRString(int id){
        return getResources().getString(id);
    }
    String generateTimeText(int seconds){
        if (seconds==-1)return getRString(R.string.unknown);
        if (seconds<10){
            return getRString(R.string.just_now);
        }else if (seconds<=60){
            return Integer.toString(seconds)+ " "+
                    getRString(R.string.seconds_ago);
        }else if (seconds>60 && seconds<=3600){
            return Integer.toString(seconds/60)+ " "+
                    getRString(R.string.minutes_ago);
        }else{
            return Integer.toString(seconds/3600)+ " "+
                    getRString(R.string.hours_ago);
        }
    }
    private void setTextLastServerConnection(Date date) {
        tvConnection.setText(generateTimeText(calculateSeconds(date)));
    }

    void setTextLastGPS(Date date){
        tvGPS.setText(generateTimeText(calculateSeconds(date)));
    }

    void setWeightTextView(TextView tv, int weight, int column){
        TableRow.LayoutParams params =
                new TableRow.LayoutParams(0, TableRow.LayoutParams.MATCH_PARENT, weight);
        params.column=column;
        tv.setLayoutParams(params);
    }

    void setBackgroundTextView(TextView tv){
        tv.setBackgroundResource(R.drawable.cell_shape);
        tv.setTextAppearance(this, R.style.AppTheme_TableRow);
    }
    void setBackgroundCaptionTextView(TextView tv){
        tv.setBackgroundResource(R.drawable.cell_shape);
        tv.setTextAppearance(this, R.style.AppTheme_TableHeader);
    }

    void AddTableCaption(){
        TableRow tableRow=new TableRow(this);

        TableRow.LayoutParams trlp=new TableRow.LayoutParams();
        trlp.width=TableRow.LayoutParams.MATCH_PARENT;
        tableRow.setLayoutParams(trlp);/**/

        //State
        TextView tv=new TextView(this);

        setBackgroundCaptionTextView(tv);
        tv.setText(getRString(R.string.state));
        setWeightTextView(tv, 2, 0);
        tableRow.addView(tv);

        //Date
        tv=new TextView(this);
        setBackgroundCaptionTextView(tv);
        tv.setText(getRString(R.string.sample_date));
        setWeightTextView(tv, 3, 1);
        tableRow.addView(tv);

        //Latitude
        tv=new TextView(this);
        setBackgroundCaptionTextView(tv);
        tv.setText(getRString(R.string.latitude));
        setWeightTextView(tv, 3, 2);
        tableRow.addView(tv);

        //Longitude
        tv=new TextView(this);
        setBackgroundCaptionTextView(tv);
        tv.setText(getRString(R.string.longitude));
        setWeightTextView(tv, 3, 3);
        tableRow.addView(tv);
        table.addView(tableRow, 0);
    }

    String getZero(int i){
        String formatted = String.format("%02d", i);
        return formatted;
    }
    void ProcessLocation(TrackItService.TrackLocation location){


        try {
            //если это обновление статуса
            if (locationTable.indexOfKey(location.TimeStamp)>=0){
                TableRow tr = (TableRow)locationTable.get(location.TimeStamp);
                TextView txtvSatete =(TextView)tr.getChildAt(0);
                txtvSatete.setText(getState(location.State));
                return;
            }

            TableRow tableRow=new TableRow(this);

            TableRow.LayoutParams trlp=new TableRow.LayoutParams();
            trlp.width=TableRow.LayoutParams.MATCH_PARENT;
            tableRow.setLayoutParams(trlp);/**/

            //State
            TextView tvState=new TextView(this);

            setBackgroundTextView(tvState);
            tvState.setText(getState(location.State));
            setWeightTextView(tvState, 2, 0);
            tableRow.addView(tvState);

            //Date
            TextView tvDate=new TextView(this);
            java.util.Date dt=new java.util.Date((long)location.TimeStamp*1000);
            Calendar cal=Calendar.getInstance(TimeZone.getTimeZone("UTC"));
            cal.setTime(dt);
            cal.setTimeZone(TimeZone.getDefault());
            String datetime = cal.get(Calendar.YEAR)+"."+
                    getZero(cal.get(Calendar.MONTH) + 1) + "." +
                    getZero(cal.get(Calendar.DAY_OF_MONTH)) + " " +
                    getZero(cal.get(Calendar.HOUR_OF_DAY)) + ":" +
                    getZero(cal.get(Calendar.MINUTE)) + ":" +
                    getZero(cal.get(Calendar.SECOND));
            setBackgroundTextView(tvDate);
            tvDate.setText(datetime);

            setWeightTextView(tvDate, 3, 1);
            tableRow.addView(tvDate);

            //Latitude
            TextView tvLatitude=new TextView(this);
            setBackgroundTextView(tvLatitude);
            tvLatitude.setText(Double.toString(location.Latitude));


            setWeightTextView(tvLatitude, 3, 2);
            tableRow.addView(tvLatitude);

            //Longitude
            TextView tvLongitude=new TextView(this);
            setBackgroundTextView(tvLongitude);
            tvLongitude.setText(Double.toString(location.Longitude));
            setWeightTextView(tvLongitude, 3, 3);
            tableRow.addView(tvLongitude);

            locationTable.append(location.TimeStamp, tableRow);

            //add tablerow: Calculte index
            //ищем ближайшего большего
            int minTs=Integer.MAX_VALUE;
            if (locationTable.size()>0) {
                for (int i = 0; i < locationTable.size(); i++) {
                    int ts = locationTable.keyAt(i);
                    if (ts <= location.TimeStamp) continue;
                    if (ts < minTs) minTs = ts;
                }
            }
            //Вычисляем индекс в таблице и ставим за ним
            if (minTs!=Integer.MAX_VALUE){
                TableRow row=
                        (TableRow)locationTable.get(minTs);
                int rowIndex = table.indexOfChild(row);
                if (rowIndex!=-1){
                    table.addView(tableRow,rowIndex+1);
                }else{
                    table.addView(tableRow,1);
                }
            }else {
                table.addView(tableRow, 1);
                table.refreshDrawableState();
            }

            int hMax = tvDate.getHeight();
            if (tvState.getHeight()<hMax) {
                tvState.setHeight(hMax);
                tvLatitude.setHeight(hMax);
                tvLongitude.setHeight(hMax);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String getState(int state){
        switch (state){
            case TrackItService.TrackLocation.STATE_NEW:
                return getRString(R.string.newdata);
            case TrackItService.TrackLocation.STATE_REJECTED:
                return getRString(R.string.rejected);
            case  TrackItService.TrackLocation.STATE_SAVED:
                return getRString(R.string.saved);
            case TrackItService.TrackLocation.STATE_SENT:
                return getRString(R.string.sent);
        }
        return getRString(R.string.unknown);
    }



    @Override
    protected void onStart() {
        super.onStart();
        bindService(serviceIntent, serviceConnection, 0);
        AddTableCaption();
        if (serviceBound){
            service.theHandler.sendEmptyMessage(TrackItService.SMSG_REQUEST_DBDATA);
        }

    }

    @Override
    protected void onStop() {
        super.onStop();
        if (serviceBound) {
            unbindService(serviceConnection);
            serviceBound = false;
        }
        table.removeAllViews();
    }

    @Override
    protected void onDestroy() {
        service.stopService();
        super.onDestroy();
    }

    public void Deb(String log_tag, Object obj) {
        if (obj != null) {
            String txt = obj.toString();
            Log.d(log_tag, txt);
            debugText.append(txt);
            debugText.append("\r\n");
        }
    }

    public void Deb(Object obj) {
        Deb(LOG_TAG,obj);
    }






}
