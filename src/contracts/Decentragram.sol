//SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.11;

contract Decentragram {
  string public name = "Decentragram";
  
  // Storing Images
  uint public imageCount = 0;
  mapping(uint => Image) public images;

  struct Image {
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  event ImageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  //Creating Images
  function uploadImage(string memory _imgHash, string memory _description) public{
    
    //Make sure the image hash exists
    require(bytes(_imgHash).length > 0);

    //Description must be at least 1 character
    require(bytes(_description).length > 0);

    //Make sure uploader address exists
    require(msg.sender != address(0));

    //Increment Image ID;
    imageCount++;

    //Add images to contract
    images[imageCount] = Image(imageCount,_imgHash, _description, 0, payable(msg.sender));

    // Trigegr an event
    emit ImageCreated(imageCount, _imgHash,_description,0,payable(msg.sender));
  }

  //Tip image owner
  function tipImageOwner(uint _id) public payable{
    //Make sure the id is valid 
    require(_id > 0 && _id <= imageCount);
    //Fetch the image from storage
    Image memory _image = images[_id];
    //Image author
    address payable _author = _image.author;
    //Pay the author by sending them ether
    payable (address(_author)).transfer(msg.value);
    //Increment the tip amount
    _image.tipAmount = _image.tipAmount + msg.value;
    //Update the image
    images[_id] = _image;
  

    // Trigger an event
    emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);
  }
  

}