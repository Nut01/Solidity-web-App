// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Testament {
    //  Create a Variable
    address manager;
    mapping(address => address) _heir; // เก็บข้อมูลผู้รับมรดก
    mapping(address => uint256) balance; // เก็บข้อมูลมรดก

    // Create Event for Create Testament
    event createTestament(
        address indexed owner,
        address indexed heir,
        uint256 amount
    ); // สร่าง Event เพื่อแจ้งเตือนว่า มรดกถูกสร้างแล้ว ใส่ indexed เพื่อให้สามารถตรวจสอบข้อมูล Address ได้

    // Create Event for Report
    event reportTestament(
        address indexed owner,
        address indexed heir,
        uint256 amount
    ); // สร่าง Event เพื่อแจ้งเตือนว่า มรดกถูกโอนให้ผู้รับมรดกแล้ว

    // Create a Constructor
    constructor() {
        manager = msg.sender; // ใครเป็นคน Deploy Contract จะเป็นผู้จัดการ
    }

    // Function for Owner Create Testament
    function create(address heir) public payable {
        require(msg.value > 0, "Please enter more than 0 ETH."); // สร้าง requirement ให้มีมูลค่ามากกว่า 0 TREI
        require(balance[msg.sender] <= 0, "You already have a testament."); // สร้าง requirement ห้ามเขียนพินัยกรรมซ้ำ
        _heir[msg.sender] = heir; // เก็บข้อมูลเลขกระเป๋าผู้รับมรดก
        balance[msg.sender] = msg.value; // เก็บข้อมูลมูลค่ามรดก
        emit createTestament(msg.sender, heir, msg.value); // เรียกใช้ Event
    }

    // Function getTestament
    function getTestament(address owner) 
        public
        view
        returns (address heir, uint256 amount)  
    {
        // สร้าง Function สำหรับดูข้อมูลพินัยกรรม
        return (_heir[owner], balance[owner]); // ส่งข้อมูลผู้รับมรดก และ มูลค่ามรดก กลับไป ระบุด้วยเลขกระเป๋าเจ้าของมรดก
    }

    // Function for Manager to Report Testament to Heir
    function report(address owner) public {
        require(msg.sender == manager, "You are not the manager."); // สร้าง requirement ว่าเป็นเลขกระเป๋าผู้จัดการเท่านั้น
        require(balance[owner] > 0, "This owner does not have a testament."); // สร้าง requirement ว่าเจ้าของมรดกมีพินัยกรรม
        emit reportTestament(owner, _heir[owner], balance[owner]); // เรียกใช้ Event reportTestament
        payable(_heir[owner]).transfer(balance[owner]); // โอนมรดกให้ผู้รับมรดก
        balance[owner] = 0; // ลบข้อมูลมรดก
        _heir[owner] = address(0); // ลบข้อมูลผู้รับมรดก
    }

    
}
