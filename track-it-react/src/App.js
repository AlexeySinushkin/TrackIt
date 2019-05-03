import React from 'react';
import logo from './logo.svg';
import './App.css';

function App() {
  return (
    <div className="row main-content">
      <div className="col-sm-1"></div>
      <div className="col dark-style">
        <div className="row">
          <div className="col-sm main-left dark-style">
            <p>Track It - это бесплатный сервис по сбору данных о 
              местоположении смартфона, мото-=сигнализации и любого устройства, 
              поддерживающего <a href="/gate-free.asmx">протокол</a> работы</p>
              <p>Мы не спрашиваем как Вас зовут и другие персональные данные.
                  Для идентификации используется IMEI вашего смартфона. Для того, чтобы узнать 
                  IMEI, нужно набрать *#06#
              </p>
              <p>
                  Для того, чтобы данные начали появляться, нужно установить приложение <a href="https://play.google.com/store/apps/details?id=ru.track_it.trackit">TrackIt</a> из
                  Google Play Market<a href="/view-free.aspx?testing=1">.</a>
              </p>
          </div>
        </div>
      </div>
      <div className="col main-shadow shadow-width"></div>
      <div className="col-sm main-right">
        <h5>Также мы</h5>
        <ul>
          <li>Не сохраняем IP адрес входящего подключения</li>
          <li>Не имеем базы данных. В случае перезагрузки сервера данные будут стерты.</li>
          <li>Осуществялем хостинг на домашнем ПК, что не позволит некоторым лицам делать запросы напрямую к серверу.</li>
        </ul>
      </div>
      <div className="col-sm-1"></div>
    </div>
  );
}

export default App;
