//SPDX-License-Identifier:MIT

/**
 * if deadline is not met person can addvote for proposal
 * we are able to see which address voted yes and which voted no
 * for deadline => we are playing with time 2-options 1) oracles for time 2) a boolean that can be  or we can think any other solution
 * deadline should be changable
 * tokenID is a ID given to all given DAO members who has some stake.
 * only owner can change deadline
 * a person can vote only one time
 */

pragma solidity ^0.8.0;

contract RapDao {
    //Type declarations
    //close-0,open-1
    enum State {
        CLOSE,
        OPEN
    }

    //state variables

    address private owner;
        uint256 private immutable i_votingFee;
    uint256 private yesCount;
    uint256 private noCount;
    State private votingState;

    //errors
    error NotOwner();
    error votingStateIsClose();
    error AlreadyVoted();
    error SendMoreToVote();
    //Member details- this has been made in previos contacts

    struct DaoMember {
        uint256 tokenId;
        bool isvoted;
    }

    //events
    //whenever a person votes and monoitor offchain which addres voted to yes or no

    event voted(address indexed member, bool indexed response);
    //whenever owner is changed
    event OwnerSet(address indexed oldOwner, address indexed newOwner);

    //I hope we have created this mapping in early stage i.e if a member want to be member of DAO he can put some stake and get a tokenId
    //tokenId represents a sort of a user ID in the DAO
    mapping(address => DaoMember) public addressToDaoMember;
    //tokenId is linked with address of DAO member so from this mapping we are storing the vote given by member
    //or we can emit events and see store this from frontend
    mapping(uint256 => bool) public tokenIdToVote;

    //setting contract deployer to owner
    constructor(uint256 votingFee) {
        owner = msg.sender;
        votingState=State.OPEN;
        i_votingFee=votingFee;
    }

    //modifier to check if caller is owner or not
    modifier isOwner() {
        if(msg.sender != owner){
            revert NotOwner();
        }
        _;
    }

    //in case if contract owner want to change to new address
    function changeOwner(address newOwner) private isOwner {
        owner = newOwner;
        emit OwnerSet(owner, newOwner);
    }

    //for vote in favour or unfavour

    function addVote(bool response) public payable {
         if (msg.value < i_votingFee) {
            revert SendMoreToVote();
        }
        DaoMember memory daomember = addressToDaoMember[msg.sender];
        //uint256 TokenId = daomember.tokenId;
        bool IsVoted = daomember.isvoted;

        if(votingState!=State.OPEN){
            revert votingStateIsClose();
        }
        if(IsVoted){
            revert AlreadyVoted();
        }
        if (response) {
            IsVoted=true;
            yesCount++;
        } else {
            noCount++;
        }
        IsVoted = true;
        emit voted(msg.sender, response);
    }

    //set deadline=> we don't want everyone can set deadline so we
    //will allow only owner to set deadline

    function stopVoting() public payable {
        if(msg.sender != owner){
            revert NotOwner();
        }
        votingState=State.CLOSE;
    }
    function startVoting() public payable {
       if(msg.sender != owner){
            revert NotOwner();
        }
        votingState=State.OPEN;
    }

    function getTotalVoteInfavour() public view returns(uint256){
        return yesCount;
    }
    function getTotalVoteInOpposite() public view returns(uint256){
        return noCount;
    }
    function getVotingState() public view returns(State){
        return votingState;
    }
    function getVotingFee() public view returns(uint256){
        return i_votingFee;
    }
}
