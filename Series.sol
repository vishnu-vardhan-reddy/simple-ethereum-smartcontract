//SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 < 0.7.0;

//import 'app/node_modules/openzeppelin-solidity/contracts/access/Ownable.sol';
//import 'app/node_modules/openzeppelin-solidity/contracts/math/Safemath.sol';

contract Series{
 // using Safemath for uint;
  string public title;
  uint public pledgePerEpisode;
  uint public minimumPublicationPeriod;

  address payable owner;

  mapping(address =>uint)public pledges;
  address[] pledgers;
  uint public lastPublicationBlock;
  mapping(uint => string) public publishedEpisodes;
  uint public episodeCounter;

  modifier onlyOwner(){
    require(msg.sender == owner, "OOPS BuDDY , you are not the owner of this contract");
    _;
  }

  constructor(string memory _title, uint _pledgePerEpisode, uint _minimumPublicationPeriod) public {
    owner = msg.sender;
    title = _title;
    pledgePerEpisode = _pledgePerEpisode;
    minimumPublicationPeriod = _minimumPublicationPeriod;
  }

  function pledge() public payable {
    require(pledges[msg.sender]+(msg.value) >= pledgePerEpisode,"pledge must be greater than pledge per episode");
    require(msg.sender != owner,"owner cannot pledge on his own series");

    bool oldPledger = false;
    for(uint i = 0; i < pledgers.length; i++){
      if(pledgers[i] == msg.sender){
        oldPledger = true;
        break;
      }
    }
    if(!oldPledger){
       pledgers.push(msg.sender);
    }
    pledges[msg.sender] = pledges[msg.sender]+(msg.value);
  }

  function withDraw() public {
        uint amount = pledges[msg.sender];
        if(amount > 0 ){
          pledges[msg.sender] = 0;
          msg.sender.transfer(amount);
        }
  }

  function publish(string memory episodeLink) public payable onlyOwner{
      require(lastPublicationBlock == 0 || block.number > lastPublicationBlock+(minimumPublicationPeriod),"Owner cannot publish to soon");
      lastPublicationBlock = block.number;
      episodeCounter++;
      publishedEpisodes[episodeCounter] = episodeLink;

      uint episodePay = 0;
      for(uint i = 0; i < pledgers.length; i++){
        if(pledges[pledgers[i]] >= pledgePerEpisode){
           pledges[pledgers[i]] = pledges[pledgers[i]]-(pledgePerEpisode);
           episodePay = episodePay+(pledgePerEpisode);
        }
      }
      owner.transfer(episodePay);
  }

  function close() public onlyOwner{
      for(uint i = 0; i < pledgers.length; i++){
        if(pledges[pledgers[i]] > 0){
         address(uint160(pledgers[i])).transfer(pledges[pledgers[i]]);
        }
      }
      selfdestruct(owner);
  }
  function totalPledgers() public view returns(uint){
    return pledgers.length;
  }

  function activePledgers() public view returns(uint) {
    uint active = 0;
    for(uint i = 0; i < pledgers.length; i++){
      if(pledges[pledgers[i]] > pledgePerEpisode){
        active++;
      }
    }
    return active;
  }

  function nextEpisodePay() public view returns(uint){
    uint episodePay = 0;
    for(uint i = 0;i < pledgers.length; i++){
      if(pledges[pledgers[i]] > pledgePerEpisode){
        episodePay = episodePay+(pledgePerEpisode);
      }
    }
    return episodePay;
  }
}
