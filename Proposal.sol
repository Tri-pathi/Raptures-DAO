//SPDX-License-Identifier:MIT

//if deadline is not met person can addvote for proposal
//we are able to see which address voted yes and which voted no
//for deadline => we are playing with time 2-options 1) oracles for time 2) a boolean that can be  or we can think any other solution
//deadline should be changable
//tokenID is a ID given to all given DAO members who has some stake.
//only owner can change deadline
//a person can vote only one time

pragma solidity ^0.8.0;

contract Proposal {
    address private owner;
    uint256 private yesCount;
    uint256 private noCount;
    bool private openForVote;

    
    struct DaoMember {
        uint256 tokenId;
        bool isvoted;
    }

    //events
    //whenever a person votes
    event voted(address member, bool response);
    //whenever owner is changed
    event OwnerSet(address oldOwner, address newOwner);


    //I hope we have created this mapping in early stage i.e if a member want to be member of DAO he can put some stake and get a tokenId
    //tokenId represents a sort of a user ID in the DAO
    mapping(address => DaoMember) public addressToDaoMember;
    //tokenId is linked with address of DAO member so from this mapping we are storing the vote given by member
    mapping(uint256 => bool) public tokenIdToVote;

    //setting contract deployer to owner
    constructor() {
        owner = msg.sender;
        openForVote=false;
    }

    //modifier to check if caller is owner or not
    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }
    //in case if contract owner want to change to new address
    function changeOwner(address newOwner) private isOwner {
        owner = newOwner;
        emit OwnerSet(owner, newOwner);
}

    //for vote in favour or unfavour

    function vote(bool  response) public {
        DaoMember memory daomember=addressToDaoMember[msg.sender];
        uint256 TokenId=daomember.tokenId;
        bool  IsVoted=daomember.isvoted;
        require(!openForVote,"Bro We are not taking response for this proposal");
        require(IsVoted,"You have already voted");
        if(response){
            tokenIdToVote[TokenId]=true;
            yesCount++;
        }else{
            tokenIdToVote[TokenId]=false;
            noCount++;
        }
        IsVoted=true;
        emit voted(msg.sender,response);
    }

    //set deadline=> we don't want everyone can set deadline so we 
    //will allow only owner to set deadline

    function stopVoting() public {
        require(msg.sender==owner,"caller is not owner");
        openForVote=false;

    }
    function startVoting() public{
        require(msg.sender==owner,"caller is not owner");
        openForVote=true;
    }

    
}
