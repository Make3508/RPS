// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Rock_Paper_Scissors{
   // uint8 option;
   // uint256 public _compChoice;
    //1 BNB = 10^9 gwei
    //1 BNB = 10^18 wei

    //0.0001 BNB = 100000
        //modifier onlyOwner
    modifier onlyOwner{
        require(msg.sender == owner);
        _;  
        //не понял зачем добавляем подчеркивание
        //возможно модификатор не иожет быть пустым
    }

    //Owner's address
    address owner; 

    constructor() payable {
        owner = msg.sender;
    }

    //address - адрес игрока, compChoice - выбор компьютера, winner - результат игры
    event GamePlayed(address player, uint256 compChoice, uint8 winner);
 
    //Генератор псевдослучайного числа подсмотрел в интернете   
    uint seed = 0;
    function Rnd(uint _modulus)  private  returns(uint){
    seed++;
    return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender,seed))) % _modulus;
  }

    //Переделал, функция будет возращать 0-проиграл игрок, 1-выиграл игрок, 2-ничья (одинаковый выбор у игрока и компьютера)
    function playGame(uint8 _option) public payable returns (uint8){
        require(_option <3, "You can choose only 0, 1 or 2");
        require(address(this).balance >= msg.value*2, "Address do not have sufficient balance");
             
    
       // uint256 _output = block.timestamp*block.gaslimit%3;//output = 0 (камень), 1 (ножницы) или 2 (бумага) //зависает этот вариант

       uint256 _output = Rnd(3);
 
        bool f = false;
        
     /*   while (_output==_option) //исключаем ничейный результат
        {
            _output = Rnd(3);//result = 0, 1 или 2
        }*/

       //все таки решил, что контракт должен выдавать ничейный результат
        if (_output==_option){
            //возращаем, что ничья и ставку
            payable(msg.sender).transfer(msg.value);
            emit GamePlayed(msg.sender, _output, 2);            
            return 2;
        }

        if (_output==0){
            if(_option == 1){ //камень бьет ножницы
                f = false;
            }    
            else{
                f = true;
            }
        }

        if (_output==1){
            if(_option == 2){ //ножницы режут бумагу
                f = false;
            }    
            else{
                f = true;
            }
        }
        if (_output==2){
            if(_option == 0){ //бумага покрывает камень
                f = false;
            }    
            else{
                f = true;
            }
        }
        if (f){
            payable(msg.sender).transfer(msg.value*2);
            emit GamePlayed(msg.sender, _output, 1);
            return 1;
        }
        else{
            emit GamePlayed(msg.sender, _output, 0);            
            return 0;
        }

    }
    //Можно вернуть денежку с контракта
    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }


}