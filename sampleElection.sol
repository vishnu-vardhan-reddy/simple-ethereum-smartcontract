// -------------------------------------------------------------------------------------------------------------------------------------
//                          mmmmm            ELECTION BETWEEN TWO CANDIDATES
//--------------------------------------------------------------------------------------------------------------------------------------

pragma solidity 0.4.20;

contract SampleElection{
    
 struct Candidate {
     uint id;
     string name;
     uint voteCount;
 }
 
 // Store accounts that have voted : the voter's adress is set to true if voted so that the voter cannot  vote again
 mapping(address => bool) public voters;
 
 //Store Candidates also can fetch
 mapping(uint => Candidate) public candidates;
 
 //Store candidates count
 uint public candidateCount;
 
 event votedEvent(uint indexed _candidateId);
 
 
 function election() public{
     addCandidate("vishnu");
     addCandidate("vicky");
 }
 
 function addCandidate(string memory _candidate) private{
     
     candidateCount++;
     candidates[candidateCount] = Candidate(candidateCount , _candidate , 0);
     
 }
 
 function vote (uint _candidateId) public{
     
     // checking that the voter has already voted 
     require(!voters[msg.sender]);
     
     // _candidateId must be greater thsn zero && lessthan total candidateCount
     require(_candidateId > 0 && _candidateId <=candidateCount );
     
     // vote is consumed by the voter so the voter adress is set to true 
     voters[msg.sender] = true ;
     
     //candidate votes is increased by one
     candidates[_candidateId].voteCount++;
     
     //trigger votedevent
     votedEvent(_candidateId);
 
 }
     
}

