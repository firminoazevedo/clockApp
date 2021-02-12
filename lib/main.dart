import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Pomodoro(),
  ));
}

class Pomodoro extends StatefulWidget {
  @override
  _PomodoroState createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  bool tempoDeEstudo = false;
  bool comecou = false;
  double porcentagem = 0.0;
  static int tempoInMinutos = 25;
  int tempoInSec = tempoInMinutos * 60;
  int pauseTime = 5;
  Timer timer;

  _pararContador(){
    comecou = false;
    tempoInMinutos = tempoDeEstudo ? 5 : 25;
    print(tempoDeEstudo);
    setState(() {
    });
  }

  _comecarContador(){
    comecou = true;
    porcentagem = 0.0;
    int time = tempoInMinutos * 60;
    double secPorcentagem = (time/100);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!comecou){
        timer.cancel();
      }
      setState(() {
        print(time);
        if (time>0){
            time--;
        if (time % 60 == 0){ // Um minuto se passou
          tempoInMinutos --;
        }
        if (time % secPorcentagem == 0){ //queremos ver 1% é igual a quantos segundos para nossa barra de progresso
          if(porcentagem < 0.99){
            porcentagem += 0.01;
          } else {
            porcentagem = 1;
          }
        }
      } else {
        porcentagem = 0.0;
        timer.cancel();
        comecou = false;
        showDialog(context: context,
          builder: (BuildContext context) => AlertDialog(
          title: Text('Tempo terminado!'),
          content: Text('Começar tempo de ${tempoDeEstudo ? "estudo": "pausa" }'),
          actions: [
            FlatButton(onPressed: (){
              tempoDeEstudo = true;
              tempoInMinutos = tempoDeEstudo ? 5 : 25;
              _comecarContador();
              Navigator.of(context).pop();
            }, child: Text('Sim')),
            FlatButton(onPressed: (){
              tempoInMinutos = 25;
              tempoDeEstudo = false;
              Navigator.of(context).pop();
            }, child: Text('Não'))
          ],
        ));
      }
    });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff1542bf), Color(0xff51a8ff)],
              begin: FractionalOffset(0.5, 1),
            )
          ),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Text('Pomodoro Clock', style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                ),),
              ),
              // CIRCULAR PERCENT INDICATOR
              Expanded(
                child:CircularPercentIndicator(
                  circularStrokeCap: CircularStrokeCap.round,
                  percent: porcentagem,
                  radius: 250,
                  animation: true,
                  animateFromLastPercent: true,
                  lineWidth: 20,
                  progressColor: Colors.white,
                  center: Text('$tempoInMinutos', style: TextStyle(
                    color: Colors.white,
                    fontSize: 45,
                  ),),
              )),
            SizedBox(height: 30,),
            // CONTAINER RODAPÉ
            Expanded(child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(65),
                  topRight: Radius.circular(65)
                  )
              ),
              child: Padding(padding: const EdgeInsets.only(top: 30, right: 40, left: 40,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text('Tempo para estudar'),
                            Text('25', style: TextStyle(
                              fontSize: 50,
                              color: Colors.grey[800]
                            ),),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text('Pausa Tempo'),
                            Text('$pauseTime', style: TextStyle(
                              fontSize: 50,
                              color: Colors.grey[800]
                            ),),
                          ],
                        ),
                      ),
                    ],),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 22.0),
                      // Botão começar a estudar
                      child: FlatButton(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        onPressed: comecou ? _pararContador : _comecarContador,
                      textColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: !comecou ? Text('Começar') : Text('Cancelar'),
                      )),
                    )
                  ],
                ),
              ),
            ),)
        ],
      ),
    ),
  ),
);
 }
}