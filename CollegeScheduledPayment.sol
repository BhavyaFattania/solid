// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/** Classroom demo: student prefunds escrow. Demo mode bypasses date checks.
 * Real mode allows one 15 ETH payment each January 6 and August 6 (UTC).
 * A user or automation service must call payScheduledFee(). */
contract CollegeScheduledPayment {
    address payable public immutable student;
    address payable public immutable college;
    bool public immutable demoMode;
    uint256 public constant PAYMENT_AMOUNT = 15 ether;
    mapping(uint256 => bool) public paidForPeriod;

    event Funded(address indexed student, uint256 amount);
    event PaymentSent(
        uint256 indexed year,
        uint256 indexed month,
        uint256 amount
    );
    event FundsWithdrawn(uint256 amount);

    modifier onlyStudent() {
        require(msg.sender == student, "Only the student can do this");
        _;
    }

    constructor(address payable _college, bool _demoMode) {
        require(_college != address(0), "College address cannot be zero");
        student = payable(msg.sender);
        college = _college;
        demoMode = _demoMode;
    }

    function fund() external payable onlyStudent {
        require(msg.value > 0, "Send some ETH");
        emit Funded(msg.sender, msg.value);
    }

    function payScheduledFee() external {
        (uint256 year, uint256 month, uint256 day) =
            _dateFromTimestamp(block.timestamp);

        require(
            demoMode || (day == 6 && (month == 1 || month == 8)),
            "Payment is due only on Jan 6 or Aug 6 (UTC)"
        );

        uint256 period = year * 100 + month;

        require(!paidForPeriod[period], "This period is already paid");
        require(
            address(this).balance >= PAYMENT_AMOUNT,
            "Contract needs at least 15 ETH"
        );

        paidForPeriod[period] = true;

        (bool success, ) = college.call{value: PAYMENT_AMOUNT}("");
        require(success, "Transfer to college failed");

        emit PaymentSent(year, month, PAYMENT_AMOUNT);
    }

    function withdrawUnusedFunds(uint256 amount) external onlyStudent {
        require(
            amount <= address(this).balance,
            "Not enough ETH in contract"
        );

        (bool success, ) = student.call{value: amount}("");
        require(success, "Withdrawal failed");

        emit FundsWithdrawn(amount);
    }

    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function _dateFromTimestamp(uint256 timestamp)
        internal
        pure
        returns (uint256 year, uint256 month, uint256 day)
    {
        int256 z = int256(timestamp / 86400) + 719468;
        int256 era = z / 146097;
        uint256 dayOfEra = uint256(z - era * 146097);

        uint256 yearOfEra = (
            dayOfEra
            - dayOfEra / 1460
            + dayOfEra / 36524
            - dayOfEra / 146096
        ) / 365;

        int256 calculatedYear = int256(yearOfEra) + era * 400;

        uint256 dayOfYear = dayOfEra - (
            365 * yearOfEra + yearOfEra / 4 - yearOfEra / 100
        );

        uint256 monthPart = (5 * dayOfYear + 2) / 153;

        day = dayOfYear - (153 * monthPart + 2) / 5 + 1;
        month = monthPart < 10 ? monthPart + 3 : monthPart - 9;
        year = uint256(
            calculatedYear + (month <= 2 ? int256(1) : int256(0))
        );
    }
}
