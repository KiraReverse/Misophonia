using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StunState : BaseBehavior
{
    public StateController stateCon;
    public ChaseState chase;
    public EnemyDetection eyes;
    public float stunDuration;

    float timeStart;
    

    // Use this for initialization
    void Start ()
    {
		
	}

    public override void Enter()
    {
        timeStart = Time.timeSinceLevelLoad;

        StartCoroutine(CloseEyes());
        stateCon.CurrState = StateController.State.stun;
    }

    public override void Exit()
    {
        eyes.playerInSight = false;
        stateCon.CurrState = StateController.State.ponderEnter;
    }

    public override void StateLoop()
    {
        if(Time.timeSinceLevelLoad >= timeStart + stunDuration)
        {
            stateCon.CurrState = StateController.State.stunExit;
        }
    }

    // Update is called once per frame
    void Update ()
    {
		
	}

    public void StunInterrupt()
    {
        stateCon.nextState = StateController.State.stunEnter;

        if (stateCon.nextState != stateCon.GetCurrEnterState())
        {
            stateCon.interrupt = true;
            return;
        }
    }

    IEnumerator CloseEyes()
    {
        eyes.GetComponent<Collider2D>().enabled = false;
        yield return new WaitForSeconds(stunDuration);
        eyes.GetComponent<Collider2D>().enabled = true;
    }
}
