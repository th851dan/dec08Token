// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

contract Jan08Token is ERC20, ERC20Burnable, AccessControlEnumerable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    mapping(bytes16 => address[]) rewardMapAddress;
    mapping(bytes16 => uint256[]) rewardMapAmount;

    event SetRewardAddress(bytes16 id, address[] firstRewardAddress);

    constructor() ERC20("Jan08Token", "J8T") {
        _mint(msg.sender, 1500 * 10**decimals());
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function grantMinterRole(address account)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _grantRole(MINTER_ROLE, account);
    }

    function revokeMinterRole(address account)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _revokeRole(MINTER_ROLE, account);
    }

    function setRewardAddresses(bytes16 id, address[] memory addresses)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        rewardMapAddress[id] = addresses;
        emit SetRewardAddress(id, rewardMapAddress[id]);
    }

    function setRewardAmounts(bytes16 id, uint256[] memory amounts)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        rewardMapAmount[id] = amounts;
    }

    function getRewardedAddresses(bytes16 id)
        public
        view
        returns (address[] memory)
    {
        address[] memory list = rewardMapAddress[id];
        return list;
    }

    function getAllMinters() public view returns (address[] memory) {
        return getAllAddressesOfRole(MINTER_ROLE);
    }

    function getAllAdmins() public view returns (address[] memory) {
        return getAllAddressesOfRole(DEFAULT_ADMIN_ROLE);
    }

    function getAllAddressesOfRole(bytes32 role)
        internal
        view
        returns (address[] memory)
    {
        uint256 roleCount = getRoleMemberCount(role);
        address[] memory roleAddresses = new address[](roleCount);
        for (uint256 i = 0; i < roleCount; i++) {
            roleAddresses[i] = getRoleMember(role, i);
        }
        return roleAddresses;
    }
}
