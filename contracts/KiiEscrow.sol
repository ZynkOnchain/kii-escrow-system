// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract KiiEscrow {

    enum State {
        AWAITING_PAYMENT,
        AWAITING_DELIVERY,
        COMPLETE,
        DISPUTED,
        REFUNDED
    }

    struct Deal {
        address buyer;
        address seller;
        address arbiter;
        uint256 amount;
        State state;
    }

    uint256 public dealCount;
    mapping(uint256 => Deal) public deals;

    // EVENTS (important for visibility)
    event DealCreated(uint256 dealId, address buyer, address seller, uint256 amount);
    event Deposited(uint256 dealId);
    event Delivered(uint256 dealId);
    event Completed(uint256 dealId);
    event Disputed(uint256 dealId);
    event Refunded(uint256 dealId);

    modifier onlyBuyer(uint256 _id) {
        require(msg.sender == deals[_id].buyer, "Not buyer");
        _;
    }

    modifier onlySeller(uint256 _id) {
        require(msg.sender == deals[_id].seller, "Not seller");
        _;
    }

    modifier onlyArbiter(uint256 _id) {
        require(msg.sender == deals[_id].arbiter, "Not arbiter");
        _;
    }

    modifier inState(uint256 _id, State _state) {
        require(deals[_id].state == _state, "Invalid state");
        _;
    }

    // Create a new escrow deal
    function createDeal(address _seller, address _arbiter) external returns (uint256) {
        dealCount++;

        deals[dealCount] = Deal({
            buyer: msg.sender,
            seller: _seller,
            arbiter: _arbiter,
            amount: 0,
            state: State.AWAITING_PAYMENT
        });

        emit DealCreated(dealCount, msg.sender, _seller, 0);

        return dealCount;
    }

    // Buyer deposits funds
    function deposit(uint256 _id) external payable onlyBuyer(_id) inState(_id, State.AWAITING_PAYMENT) {
        require(msg.value > 0, "Amount must be > 0");

        deals[_id].amount = msg.value;
        deals[_id].state = State.AWAITING_DELIVERY;

        emit Deposited(_id);
    }

    // Seller confirms delivery
    function confirmDelivery(uint256 _id) external onlySeller(_id) inState(_id, State.AWAITING_DELIVERY) {
        deals[_id].state = State.COMPLETE;

        payable(deals[_id].seller).transfer(deals[_id].amount);

        emit Delivered(_id);
        emit Completed(_id);
    }

    // Buyer raises dispute
    function raiseDispute(uint256 _id) external onlyBuyer(_id) inState(_id, State.AWAITING_DELIVERY) {
        deals[_id].state = State.DISPUTED;

        emit Disputed(_id);
    }

    // Arbiter resolves dispute (true = release to seller, false = refund buyer)
    function resolveDispute(uint256 _id, bool releaseToSeller) external onlyArbiter(_id) inState(_id, State.DISPUTED) {
        if (releaseToSeller) {
            deals[_id].state = State.COMPLETE;
            payable(deals[_id].seller).transfer(deals[_id].amount);
            emit Completed(_id);
        } else {
            deals[_id].state = State.REFUNDED;
            payable(deals[_id].buyer).transfer(deals[_id].amount);
            emit Refunded(_id);
        }
    }
}
