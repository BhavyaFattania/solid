# Student-to-College Scheduled ETH Payment

A small Solidity classroom prototype that transfers **15 ETH to a college on January 6 and August 6 each year**. Demo mode allows the transfer to be demonstrated today with fake ETH.

## How it works

The student deploys the contract, supplies the college address, and deposits ETH into the contract. A call to `payScheduledFee()` sends 15 ETH to the college. Each year/month can be paid only once.

**The contract must be funded first.** It cannot withdraw ETH directly from the student's wallet or execute automatically. A person or external automation service must trigger the payment. This project does not include an automation service.

## Files

- [CollegeScheduledPayment.sol](./CollegeScheduledPayment.sol): the standalone smart contract.
- [README.md](./README.md): complete code and instructions.

## Requirements

A browser such as Chrome or Edge and an internet connection. No Go, MetaMask, login, local installation, or real ETH is needed.

Use **Remix VM** for this demonstration. Its accounts and ETH are simulated.

## Full walkthrough

### 1. Open Remix

Open [Remix IDE](https://app.remix.live/) and close any welcome notices covering the editor.

### 2. Create the source file

1. Click **Files** on the left.
2. Click **+ Create → New file**.
3. Name it `CollegeScheduledPayment.sol` and press Enter.
4. Copy all the code from the Solidity file in this repository, or from the code block below.
5. Paste it into the Remix editor.
6. If a **New code pasted** notice appears, review and close it.

### 3. Compile

1. Open the **Compile** panel on the left.
2. Choose compiler **0.8.34**, which was used for the successful demo.
3. Click **Compile CollegeScheduledPayment.sol**. You can also use the Compile button above the editor.
4. Wait for **Compiled** with a check mark.

The source supports compatible Solidity 0.8.x versions starting at 0.8.20. Copy only the code, without the Markdown backticks.

### 4. Choose the simulated blockchain

1. Click **Deploy** on the left sidebar.
2. Set **Environment** to **Remix VM**.
3. Select **Osaka**, which was used for this demo.
4. Keep **Account 1** selected. This is the student.
5. Open the account dropdown and identify **Account 2**, which is the college. Note its starting balance.

The college address used in the demo was:

```text
0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
```

Check that it matches Account 2 in your VM. If your Account 2 has a different address, use that address instead. Return to **Account 1** before deploying. Fresh VM accounts normally start with 100 test ETH each.

### 5. Deploy

In the **Deploy** tab, select `CollegeScheduledPayment` and fill in:

| Field | Demo value |
| --- | --- |
| `_college` | `0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2` (or your Account 2 address) |
| `_demoMode` | `true` |

Keep **Value = 0** and click **Deploy**. The constructor does not accept ETH.

Open **Deployed Contracts** and expand the contract if needed.

### 6. Deposit 15 test ETH

1. Keep **Account 1** selected.
2. Find the **Value** field inside the deployed contract panel. Scroll down if needed.
3. Enter `15`.
4. Change the unit from **wei** to **ether**.
5. Find **fund** and click **Transact** beside it.

The contract's displayed **Balance** should now be **15 ETH**. The student's balance becomes approximately 85 ETH, slightly less because of simulated gas fees.

You can also click **Call** beside `contractBalance`. It returns:

```text
15000000000000000000
```

That is 15 ETH expressed in wei. **1 ETH = 1,000,000,000,000,000,000 wei.**

### 7. Transfer the payment

1. Change **Value back to 0**.
2. Find **payScheduledFee**.
3. Click **Transact** beside it.

This sends the money already deposited in the contract. Do not attach another 15 ETH to this call.

A successful transaction appears in the console or **Transaction History**. The contract balance returns to **0 ETH**.

### 8. Show the result

Select **Account 2** from the account dropdown. If it started with 100 ETH, it should now show **115 ETH**.

| Account or contract | Initial balance | After demonstration |
| --- | --- | --- |
| Student / Account 1 | 100 test ETH | About 84.999 test ETH; gas varies |
| College / Account 2 | 100 test ETH | 115 test ETH |
| Contract | 0 ETH | 0 ETH after receiving and forwarding 15 ETH |

The demonstrated run compiled with Solidity **0.8.34** in **Remix VM Osaka**. Deployment, funding, and the 15 ETH payment succeeded. This verifies the demo transfer; the calendar logic has not been exhaustively tested.

### 9. Repeat the demonstration

Calling `payScheduledFee` again in the same period fails with **This period is already paid**. This prevents a duplicate payment.

To repeat the demo, deploy a fresh contract from Account 1 and repeat the deposit and payment steps. Balances accumulate across demonstrations. Resetting the VM resets its simulated state and removes previous deployments and transactions.

## Demo mode and actual date checking

| Setting at deployment | Behavior |
| --- | --- |
| `_demoMode = true` | Allows payment on any date, once per calendar year/month. |
| `_demoMode = false` | Allows payment only on January 6 or August 6 in UTC, once per payment period. |

Demo mode cannot be changed after deployment; deploy another instance to change the setting.

The date check does not make the contract run by itself. Someone must call the function on the permitted date, with at least 15 ETH already deposited. A missed date cannot be paid later through this function. The student can withdraw unused funds, so future payments are not guaranteed.

## What to say in a presentation or viva

> Account 1 represents the student and Account 2 represents the college. The student deposits 15 ETH into the smart contract. Calling payScheduledFee transfers the money to the college. In normal mode, payments are permitted only on January 6 and August 6, once per payment period. Demo mode lets us show the transfer today using simulated ETH.

## Functions

| Function | Purpose |
| --- | --- |
| `fund()` | Student deposits ETH. |
| `payScheduledFee()` | Transfers 15 ETH after checking the date, available balance, and previous payment. Anyone may trigger it, but the recipient is always the college. |
| `contractBalance()` | Shows the contract balance in wei. |
| `withdrawUnusedFunds(amount)` | Student recovers unused funds. Enter the amount in wei. |
| `student()` | Shows the student address. |
| `college()` | Shows the college address. |
| `demoMode()` | Shows whether demo mode is enabled. |
| `PAYMENT_AMOUNT()` | Shows the fixed 15 ETH amount in wei. |
| `paidForPeriod(period)` | Shows whether a year/month was paid, e.g. `202601` for January 2026. |

## Troubleshooting

| Error or issue | Solution |
| --- | --- |
| Only the student can do this | Select the account that deployed the contract before funding or withdrawing. |
| Send some ETH | Set Value to 15 and the unit to ether before calling fund. |
| Contract needs at least 15 ETH | Fund the contract with 15 ether; check you did not choose wei. |
| Payment is due only on Jan 6 or Aug 6 (UTC) | For an immediate demo, deploy a new instance with demo mode true. |
| This period is already paid | Payment already succeeded. Deploy a new instance to repeat the demo. |
| Non-payable transaction/value error | Set Value to 0 before deploying or calling payScheduledFee. Only fund accepts a deposit. |
| College balance did not change | Check transaction success and confirm the account matches the college address used at deployment. |
| No deployed contract is visible | Compile, deploy, and open Deployed Contracts. Resetting the VM removes previous deployments. |

## Complete Solidity code

This code is identical to [CollegeScheduledPayment.sol](./CollegeScheduledPayment.sol).

```solidity
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
```

## Upload to GitHub

1. Create a GitHub repository.
2. Upload `README.md` and `CollegeScheduledPayment.sol` to its root.
3. Commit the uploaded files.

GitHub displays this README as the project page. No dependency or installation files are needed. This is a classroom prototype intended for simulated ETH.
