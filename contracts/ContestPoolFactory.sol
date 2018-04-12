pragma solidity ^0.4.19;

//import "./ContestPool.sol";
import "./ContestPoolUpgradable.sol";
import "./interface/BbStorageInterface.sol";
import "./interface/BbVaultInterface.sol";
import "./BbBase.sol";


contract ContestPoolFactory is BbBase {

     /*** events ***************/
    event CreateContestPoolDefinition(
        bytes32 indexed contestName,
        uint indexed startTime,
        uint indexed endTime,
        uint graceTime
    );
    
    event CreateContestPool(
        bytes32 indexed contestName,
        address indexed manager,
        address indexed contestPoolAddress
    );

    /**** Structs ***********/

    struct ContestPoolDefinition {
        bytes32 contestName;
        uint startTime;
        uint endTime;
        uint graceTime;
        uint maxBalance;
        uint fee;
        bool exists;
        uint ownerFee;
        uint managerFee;
    }

    /**** Properties ***********/

    mapping(bytes32 => ContestPoolDefinition) public definitions;

    /*** Modifiers ***************/

    modifier isNew(bytes32 _contestName) {
        require(!definitions[_contestName].exists);
        _;
    }

    modifier exists(bytes32 _contestName) {
        require(definitions[_contestName].exists);
        _;
    }

    /**** methods ***********/


    function ContestPoolFactory(address _storageAddress) public BbBase(_storageAddress) {
        // set version
        version = 1;
    }

    function createContestPoolDefinition(
        bytes32 _contestName, 
        uint _fee,
        uint _startTime, 
        uint _endTime, 
        uint _graceTime, 
        uint _maxBalance,
        uint _managerFee,
        uint _ownerFee) 
    onlyOwner isNew(_contestName) public 
    {
        require(_contestName != bytes32(0x0));
        require(_startTime != 0);
        require(_endTime != 0);
        require(_graceTime != 0);
        require(_maxBalance != 0);
        require(_startTime < _endTime);

        ContestPoolDefinition memory newDefinition = ContestPoolDefinition({
            contestName: _contestName,
            startTime: _startTime,
            endTime: _endTime,
            graceTime: _graceTime,
            maxBalance: _maxBalance,
            fee: _fee,
            exists: true,
            managerFee: _managerFee,
            ownerFee: _ownerFee
        });
        CreateContestPoolDefinition(
            _contestName, 
            _startTime, 
            _endTime, 
            _graceTime
        );
        definitions[_contestName] = newDefinition;
    }
        
    function createContestPool(bytes32 _contestName, uint _amountPerPlayer) 
        public payable exists(_contestName) returns (ContestPoolUpgradable) {
        require(_amountPerPlayer > 0);
        ContestPoolDefinition storage definition = definitions[_contestName];
        require(definition.fee == msg.value);
        require(definition.maxBalance > _amountPerPlayer);

        address manager = msg.sender;
        ContestPoolUpgradable newContestPoolAddress = new ContestPoolUpgradable(
            address(bbStorage),
            manager,
            definition.contestName,
            definition.startTime,
            definition.endTime,
            definition.graceTime,
            definition.maxBalance,
            _amountPerPlayer,
            definition.managerFee,
            definition.ownerFee
        );

        CreateContestPool(definition.contestName, manager, newContestPoolAddress);
        return newContestPoolAddress;
    }

    function getOwner() internal view returns (address _owner) {
        return bbStorage.getAddress(keccak256("contract.name", "bbVault"));
    }

    function getBbVault() internal view returns (BbVaultInterface _vault) {
        return BbVaultInterface(getOwner());
    }

    function withdrawFee() public onlySuperUser {
        require(this.balance > 0);
        BbVaultInterface bbVault = getBbVault();
        bbVault.deposit.value(this.balance)();
    }
}