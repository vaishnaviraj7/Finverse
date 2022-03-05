// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, 'SafeMath: addition overflow');

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, 'SafeMath: subtraction overflow');
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
       
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, 'SafeMath: multiplication overflow');

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, 'SafeMath: division by zero');
    }


    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, 'SafeMath: modulo by zero');
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


library Address {
   
    function isContract(address account) internal view returns (bool) {
    
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
    }


    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, 'Address: insufficient balance');
        (bool success, ) = recipient.call{value: amount}('');
        require(success, 'Address: unable to send value, recipient may have reverted');
    }

    
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, 'Address: low-level call failed');
    }

   
    function functionCall(address target, bytes memory data, string memory errorMessage
    ) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

  
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
    }

   
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, 'Address: insufficient balance for call');
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), 'Address: call to non-contract');

        (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }


    modifier onlyOwner() {
        require(_owner == _msgSender(), 'Ownable: caller is not the owner');
        _;
    }


    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }


    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), 'Ownable: new owner is the zero address');
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Pair {
    function sync() external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;
}

// pragma solidity ^0.6.0;

abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        require(_status != _ENTERED, 'ReentrancyGuard: reentrant call');
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }

    modifier isHuman() {
        require(tx.origin == msg.sender, 'sorry humans only');
        _;
    }
}

// pragma solidity ^0.6.0;

library TransferHelper {
    function safeApprove(
        address token,
        address to,
        uint256 value
    ) internal {
    
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            'TransferHelper::safeApprove: approve failed'
        );
    }

    function safeTransfer(
        address token,
        address to,
        uint256 value
    ) internal {
    
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            'TransferHelper::safeTransfer: transfer failed'
        );
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            'TransferHelper::transferFrom: transferFrom failed'
        );
    }

    function safeTransferETH(address to, uint256 value) internal {
        (bool success, ) = to.call{value: value}(new bytes(0));
        require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
    }
}

contract Finverse is Context, IERC20, Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using Address for address;
    using TransferHelper for address;

    string private _name = 'Finverse';
    string private _symbol = 'FIN';
    uint8 private _decimals = 18;

    mapping(address => uint256) internal _reflectionBalance;
    mapping(address => uint256) internal _tokenBalance;
    mapping(address => mapping(address => uint256)) internal _allowances;

    uint256 private constant MAX = ~uint256(0);
    uint256 internal _tokenTotal = 100000000 * 10**18;
    uint256 internal _reflectionTotal = (MAX - (MAX % _tokenTotal));

    mapping(address => bool) isTaxless;
    mapping(address => bool) internal _isExcluded;
    address[] internal _excluded;

   
    uint256[] public _taxFee;
    uint256[] public _developmentFee;
    uint256[] public _liqFee;
    uint256[] public _burnFee;

    uint256 internal _feeTotal;
    uint256 internal _developmentFeeCollected;
    uint256 internal _liqFeeCollected;
    uint256 internal _burnFeeCollected;

    bool public isFeeActive = false; 
    bool private inSwap; 
    bool public swapEnabled = true;

    uint256 public maxTxAmount = _tokenTotal.mul(10).div(1000); // 1% OF TOTAL TOKEN SUPPLY 
    uint256 public minTokensBeforeSwap = 100 * 10**18; 

    address public burnWallet;
    address public developmentWallet;
    address public developmentWallet2;

    // PRESALE
    bool public isPresale = true;
    address payable private presale;
    address public presaleWallet;
    uint256 _rate = 1 * 10**14;

    IUniswapV2Router02 public router;
    address public pair;

    event SwapUpdated(bool enabled);
    event Swap(uint256 tokensSwapped, uint256 bnbReceived, uint256 tokensIntoLiqudity);
    event AutoLiquify(address indexed token, uint256 bnbAmount, uint256 tokenAmount);

    modifier lockTheSwap() {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor(address _router, address _owner, address _burnWallet, address payable _developmentWallet, address _developmentWallet2, address payable _presale, address _presaleWallet) {
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_router);
        pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        router = _uniswapV2Router;
        burnWallet = _burnWallet;
        developmentWallet = _developmentWallet;
        developmentWallet2 = _developmentWallet2;
        presale = _presale;
        presaleWallet = _presaleWallet;

        isTaxless[_owner] = true;
        isTaxless[developmentWallet] = true;
        isTaxless[developmentWallet2] = true;
        isTaxless[burnWallet] = true;
        isTaxless[address(this)] = true;

        excludeAccount(address(pair));
        excludeAccount(address(this));
        excludeAccount(address(burnWallet));
        excludeAccount(address(developmentWallet));
        excludeAccount(address(developmentWallet2));
        excludeAccount(address(address(0)));

        _reflectionBalance[_owner] = _reflectionTotal;
        emit Transfer(address(0), _owner, _tokenTotal);

        _taxFee.push(2);
        _taxFee.push(3);
        _taxFee.push(0);

        _liqFee.push(2);
        _liqFee.push(3);
        _liqFee.push(0);

        _developmentFee.push(2);
        _developmentFee.push(2);
        _developmentFee.push(0);

        _burnFee.push(1);
        _burnFee.push(1);
        _burnFee.push(0);

        transferOwnership(_owner);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tokenTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tokenBalance[account];
        return tokenFromReflection(_reflectionBalance[account]);
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(amount, 'ERC20: transfer amount exceeds allowance')
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(subtractedValue, 'ERC20: decreased allowance below zero')
        );
        return true;
    }

    function isExcluded(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    function reflectionFromToken(uint256 tokenAmount) public view returns (uint256) {
        require(tokenAmount <= _tokenTotal, 'Amount must be less than supply');
        return tokenAmount.mul(_getReflectionRate());
    }

    function tokenFromReflection(uint256 reflectionAmount) public view returns (uint256) {
        require(reflectionAmount <= _reflectionTotal, 'Amount must be less than total reflections');
        uint256 currentRate = _getReflectionRate();
        return reflectionAmount.div(currentRate);
    }

    function excludeAccount(address account) public onlyOwner {
        require(account != address(router), 'ERC20: We can not exclude Uniswap router.');
        require(!_isExcluded[account], 'ERC20: Account is already excluded');
        if (_reflectionBalance[account] > 0) {
            _tokenBalance[account] = tokenFromReflection(_reflectionBalance[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }

    function includeAccount(address account) external onlyOwner {
        require(_isExcluded[account], 'ERC20: Account is already included');
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _tokenBalance[account] = 0;
                _isExcluded[account] = false;
                _excluded.pop();
                break;
            }
        }
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), 'ERC20: approve from the zero address');
        require(spender != address(0), 'ERC20: approve to the zero address');

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), 'ERC20: transfer from the zero address');
        require(recipient != address(0), 'ERC20: transfer to the zero address');
        require(amount > 0, 'Transfer amount must be greater than zero');

        require(isTaxless[sender] || isTaxless[recipient] || amount <= maxTxAmount, 'Max Transfer Limit Exceeds!');

        if (swapEnabled && !inSwap && sender != pair) {
            swap();
        }

        uint256 transferAmount = amount;
        uint256 rate = _getReflectionRate();

        if (isFeeActive && !isTaxless[sender] && !isTaxless[recipient] && !inSwap) {
            transferAmount = collectFee(sender, amount, rate, recipient == pair, sender != pair && recipient != pair);
        }

        _reflectionBalance[sender] = _reflectionBalance[sender].sub(amount.mul(rate));
        _reflectionBalance[recipient] = _reflectionBalance[recipient].add(transferAmount.mul(rate));

        if (_isExcluded[sender]) {
            _tokenBalance[sender] = _tokenBalance[sender].sub(amount);
        }
        if (_isExcluded[recipient]) {
            _tokenBalance[recipient] = _tokenBalance[recipient].add(transferAmount);
        }

        emit Transfer(sender, recipient, transferAmount);
    }

    function calculateFee(uint256 feeIndex, uint256 amount) internal returns(uint256, uint256) {
        uint256 taxFee = amount.mul(_taxFee[feeIndex]).div(10**(2));
        uint256 liqFee = amount.mul(_liqFee[feeIndex]).div(10**(2));
        uint256 burnFee = amount.mul(_burnFee[feeIndex]).div(10**(2));
        uint256 developmentFee = amount.mul(_developmentFee[feeIndex]).div(10**(2));
        
        _liqFeeCollected = _liqFeeCollected.add(liqFee);
        _burnFeeCollected = _burnFeeCollected.add(burnFee);
        _developmentFeeCollected = _developmentFeeCollected.add(developmentFee);
        return (taxFee, liqFee.add(burnFee).add(developmentFee));
    }

    function collectFee(
        address account,
        uint256 amount,
        uint256 rate,
        bool sell,
        bool p2p
    ) private returns (uint256) {
        uint256 transferAmount = amount;

        (uint256 taxFee, uint256 otherFee) = calculateFee(p2p ? 2 : sell ? 1 : 0, amount);
        if(otherFee != 0) {
            transferAmount = transferAmount.sub(otherFee);
            _reflectionBalance[address(this)] = _reflectionBalance[address(this)].add(otherFee.mul(rate));
            if (_isExcluded[address(this)]) {
                _tokenBalance[address(this)] = _tokenBalance[address(this)].add(otherFee);
            }
            emit Transfer(account, address(this), otherFee);
        }
        if(taxFee != 0) {
            transferAmount = transferAmount.sub(taxFee);
            _reflectionTotal = _reflectionTotal.sub(taxFee.mul(rate));
        }
        _feeTotal = _feeTotal.add(taxFee).add(otherFee);
        return transferAmount;
    }

    function swap() private lockTheSwap {
        uint256 totalFee = _liqFeeCollected.add(_developmentFeeCollected).add(_burnFeeCollected);

        if(minTokensBeforeSwap > totalFee) return;

        uint256 amountToLiquify = totalFee.mul(_liqFeeCollected).div(totalFee).div(2);
        uint256 feeSub = amountToLiquify.add(_burnFeeCollected); 
        uint256 amountToSwap = totalFee.sub(feeSub);

        address[] memory sellPath = new address[](2);
        sellPath[0] = address(this);
        sellPath[1] = router.WETH();

        uint256 balanceBefore = address(this).balance;

        _approve(address(this), address(router), totalFee);

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            sellPath,
            address(this),
            block.timestamp
        );

        uint256 amountBNB = address(this).balance.sub(balanceBefore);

        uint256 totalBNBFee = totalFee.sub(_liqFeeCollected.div(2));
        totalBNBFee = totalBNBFee.sub(_burnFeeCollected);
        
        _tokenBalance[address(this)] = _tokenBalance[address(this)].sub(_burnFeeCollected);
        _tokenBalance[burnWallet] = _tokenBalance[burnWallet].add(_burnFeeCollected);

        uint256 amountBNBLiquidity = amountBNB.mul(_liqFeeCollected).div(totalBNBFee).div(2);
        uint256 amountBNBDevelopment = amountBNB.mul(_developmentFeeCollected).div(totalBNBFee).div(2);

        if(amountBNBDevelopment > 0) payable(developmentWallet).transfer(amountBNBDevelopment);
        if(amountBNBDevelopment > 0) payable(developmentWallet2).transfer(amountBNBDevelopment);


        addLiquidity(amountToLiquify, amountBNBLiquidity);

        _liqFeeCollected = 0;
        _burnFeeCollected = 0;
        _developmentFeeCollected = 0;

        emit Swap(amountToSwap, amountBNB, amountToLiquify);
    }

    function addLiquidity(uint256 tokenAmountToLiquify, uint256 bnbAmountToLiquify) private {
        if(tokenAmountToLiquify > 0) {
            router.addLiquidityETH{value: bnbAmountToLiquify}(
                address(this),
                tokenAmountToLiquify,
                0,
                0,
                owner(),
                block.timestamp
            );
            emit AutoLiquify(address(this), bnbAmountToLiquify, tokenAmountToLiquify);
        }
    }

    function getExcludedBalance() public view returns (uint256) {
        uint256 excludedAmount;
        for (uint256 i = 0; i < _excluded.length; i++) {
            excludedAmount = excludedAmount.add(balanceOf(_excluded[i]));
        }
        return totalSupply().sub(excludedAmount);
    }

    function _getReflectionRate() private view returns (uint256) {
        uint256 reflectionSupply = _reflectionTotal;
        uint256 tokenSupply = _tokenTotal;
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_reflectionBalance[_excluded[i]] > reflectionSupply || _tokenBalance[_excluded[i]] > tokenSupply)
                return _reflectionTotal.div(_tokenTotal);
            reflectionSupply = reflectionSupply.sub(_reflectionBalance[_excluded[i]]);
            tokenSupply = tokenSupply.sub(_tokenBalance[_excluded[i]]);
        }
        if (reflectionSupply < _reflectionTotal.div(_tokenTotal)) return _reflectionTotal.div(_tokenTotal);
        return reflectionSupply.div(tokenSupply);
    }

    function setPairRouterRewardToken(address _pair, IUniswapV2Router02 _router) external onlyOwner {
        pair = _pair;
        router = _router;
    }

    function setTaxless(address account, bool value) external onlyOwner {
        isTaxless[account] = value;
    }

    function setSwapEnabled(bool enabled) external onlyOwner {
        swapEnabled = enabled;
        emit SwapUpdated(enabled);
    }

    function setFeeActive(bool value) external onlyOwner {
        isFeeActive = value;
    }

    function setTaxFee(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
        _taxFee[0] = buy;
        _taxFee[1] = sell;
        _taxFee[2] = p2p;
    }

    function setDevelopmentFee(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
        _developmentFee[0] = buy;
        _developmentFee[1] = sell;
        _developmentFee[2] = p2p;
    }

    function setBurnFee(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
        _burnFee[0] = buy;
        _burnFee[1] = sell;
        _burnFee[2] = p2p;
    }

    function setLiquidityFee(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
        _liqFee[0] = buy;
        _liqFee[1] = sell;
        _liqFee[2] = p2p;
    }

    function setBurnWallet(address wallet) external onlyOwner {
        burnWallet = wallet;
    }

    function setDevelopmentWallet(address wallet)  external onlyOwner {
        developmentWallet = wallet;
    }

    function setDevelopmentWallet2(address wallet)  external onlyOwner {
        developmentWallet2 = wallet;
    }

    function setPresale(address wallet)  external onlyOwner {
        presale = payable(wallet);
    }

    function setIsPresale(bool value)  external onlyOwner {
        isPresale = value;
    }

    function setRate(uint256 value)  external onlyOwner {
        _rate = value;
    }

    function setPresaleWallet(address wallet)  external onlyOwner {
        presaleWallet = wallet;
    }

    function setMaxTxAmount(uint256 amount) external onlyOwner {
        maxTxAmount = amount;
    }

    function setMinTokensBeforeSwap(uint256 amount) external onlyOwner {
        minTokensBeforeSwap = amount;
    }

    receive() external payable {}

    function sPresale () public payable {
        uint256 tokens = msg.value.div(_rate);
        require (isPresale, "Presale has ended");
        require (msg.value >= 50000000000000000 && msg.value <= 5000000000000000000, "Min Presale: 0.05BNB, Max Presale: 5BNB");
        tokens = tokens * 10**18;
        require (address(this).balance > 0 && tokens > 0);
        if (address(this).balance >= 0) {
            uint256 transferAmount = tokens;
            uint256 rate = _getReflectionRate();
            address sender = presaleWallet;
            address recipient = _msgSender();

        
            _reflectionBalance[sender] = _reflectionBalance[sender].sub(tokens.mul(rate));
            _reflectionBalance[recipient] = _reflectionBalance[recipient].add(transferAmount.mul(rate));

        
            if (_isExcluded[sender]) {
                _tokenBalance[sender] = _tokenBalance[sender].sub(tokens);
            }
            if (_isExcluded[recipient]) {
                _tokenBalance[recipient] = _tokenBalance[recipient].add(transferAmount);
            }

            emit Transfer(sender, recipient, transferAmount);

            presale.transfer(msg.value);
        }
    }
}
