// เป็น function ที่ใช้ในการเชื่อมต่อกับ metamask และ ganache
const getWeb3 = () => {
    return new Promise((resolve, reject) => {
        window.addEventListener("load", async () => {
            try {
                const web3 = new Web3("http://127.0.0.1:7545");
                resolve(web3);
            } catch (error) {
                reject(error);
            }
        })
    });
}

const getContract = async (web3) => {
    const data = await $.getJSON("./contracts/Testament.json");
    const netID = await web3.eth.net.getId();
    const deployedNetwork = data.networkd[netID];
    const testament = new web3.eth.Contract(data.abi, deployedNetwork && deployedNetwork.address);
    return testament;
}