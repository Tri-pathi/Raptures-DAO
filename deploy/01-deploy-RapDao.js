module.exports=async({getNamedAccounts,deployments})=>{

    const{deploy,log}=deployments;
    const {deployer}= await getNamedAccounts();
    const BASE_FEE = "250000000000000000"; //0.25 ETH
    args:[BASE_FEE];

    console.log("deploying Contract.....");
    const rapDao=await deploy("RapDao",{
        from :deployer,
        log:true,
        args:args,
        waitConfirmation: 1
    })

    console.log("Cool Deployed .... at Contract Address : ",rapDao.address);




}