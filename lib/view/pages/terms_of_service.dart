import 'package:flutter/material.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Terms Of Services')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: RichText(
            text: TextSpan(children: [
              _body('Last updated: January 2022'),
              _title('1. Your Relationship with Us'),
              _body(
                'Welcome to Smile (the \“Platform\”), which is provided by Smiling.\n'
                ' in the United States (collectively such entities will be referred to'
                ' as \“Smile\”, \“we\” or \“us\nYou are reading the terms of service (the “Terms”),\n'
                ' which governthe relationship and serve as an agreement between you ands and set '
                'forth the terms and conditions by which you may access and use the Platform and our related websites,services, applications, products and content (collectively,the \“Services”).Access tocer tain Services or features of the Services (such as, by way of example and not limitation, the ability to submit or share User Content (defined be low))may be subject to age restrictions and not available to all users of theServices.Our Services are provided for private, non-commercial use. For purposes of these Terms, “you” and “““your” means you as the user of the Services.The Terms form a legally binding agreement between you and us. Please take the time to read them carefully.'
                ' If you are under age 18, you may only use the Services with the consent of your parent or legal guardian.'
                ' Please be sure your parent or legal guardian has reviewed and discussed these Terms with you.',
              ),
              _title(
                '2. Accepting the Terms',
              ),
              _body(
                'By accessing or using our Services, you confirm that you can form a binding contract with Smile, that you accept these Terms and that you agree to comply with them. Your access to and use of our Services is also subject to our Privacy Policy and Community Guidelines, the terms of which can be found directly on the Platform, or where the Platform is made available for download, on your mobile device’s applicable app store, and are incorporated herein by reference. By using the Services, you consent to the terms of the Privacy Policy. '
                'If you are accessing or using the Services on behalf of a business or entity, then (a) “you” and “your” includes you and that business or entity, (b) you represent and warrant that you are an authorized representative of the business or entity with the authority to bind the entity to these Terms, and that you agree to these Terms on the entity’s behalf, and (c) your business or entity is legally and financially responsible for your access or use of the Services as well as for the access or use of your account by others affiliated with your entity, including any employees, agents or contractors.'
                'You can accept the Terms by accessing or using our Services. You understand and agree that we will treat your access or use of the Services as acceptance of the Terms from that point onwards.'
                'You should print off or save a local copy of the Terms for your records.',
              ),
              _title(
                '3. Changes to the Terms',
              ),
              _body(
                'We amend these Terms from time to time, '
                'for instance when we update the functionality of our Services,'
                ' when we combine multiple apps or services operated by us or our affiliates into a single combined service or app, '
                'or when there are regulatory changes. We will use commercially reasonable '
                'efforts to generally notify all users of any material changes to these Terms, '
                'such as through a notice on our Platform, however, you should look at the Terms regularly to check for such changes. We will also update the “Last Updated” date at the top of these Terms, which reflect the effective date of such Terms.'
                ' Your continued access or use of the Services after '
                'the date of the new Terms constitutes your acceptance of the new Terms. If you do not agree to the new Terms, '
                'you must stop accessing or using the Services.',
              ),
              _title(
                '4. Your Account with Us',
              ),
              _body(
                'To access or use some of our Services, you must create an account with us. When you create this account, you must provide accurate and up-to-date information. It is important that you maintain and promptly update your details and any other information you provide to us, to keep such information current and complete. You agree that you are solely responsible (to us and to others) for the activity that occurs under your account.'
                'We reserve the right to disable your user account at any time, including if you have failed to comply with any of the provisions of these Terms, or if activities occur on your account which, in our sole discretion, would or might cause damage to or impair the Services or infringe or violate any third-party rights, or violate any applicable laws or regulations.'
                '. We will provide you with further assistance and guide you through the process. Once you choose to delete your account, you will not be able to reactivate your account or retrieve any of the content or information you have added.',
              ),
              _title(
                '5. Your Access to and Use of Our Services',
              ),
              _body(
                ''
                'Your access to and use of the Services is subject to these Terms and all applicable laws and regulations. You may not:'
                '\n•	access or use the Services if you are not fully able and legally competent to agree to these Terms or are authorized to use the Services by your parent or legal guardian;'
                '\n•	make unauthorized copies, modify, adapt, translate, reverse engineer, disassemble, decompile or create any derivative works of the Services or any content included therein, including any files, tables or documentation (or any portion thereof) or determine or attempt to determine any source code, algorithms, methods or techniques embodied by the Services or any derivative works thereof;'
                '\n•	distribute, license, transfer, or sell, in whole or in part, any of the Services or any derivative works thereof'
                '\n•	market, rent or lease the Services for a fee or charge, or use the Services to advertise or perform any commercial solicitation;'
                '\n•	use the Services, without our express written consent, for any commercial or unauthorized purpose, including communicating or facilitating any commercial advertisement or solicitation or spamming;'
                '\n•	interfere with or attempt to interfere with the proper working of the Services, disrupt our website or any networks connected to the Services, or bypass any measures we may use to prevent or restrict access to the Services;'
                '\n•	incorporate the Services or any portion thereof into any other program or product. In such case, we reserve the right to refuse service, terminate accounts or limit access to the Services in our sole discretion;'
                '\n•	use automated scripts to collect information from or otherwise interact with the Services;'
                '\n•	impersonate any person or entity, or falsely state or otherwise misrepresent you or your affiliation with any person or entity, including giving the impression that any content you upload, post, transmit, distribute or otherwise make available emanates from the Services;'
                '\n•	intimidate or harass another, or promote sexually explicit material, violence or discrimination based on race, sex, religion, nationality, disability, sexual orientation or age;'
                '\n•	use or attempt to use another’s account, service or system without authorization from Smile, or create a false identity on the Services;'
                '\n•	use the Services in a manner that may create a conflict of interest or undermine the purposes of the Services, such as trading reviews with other users or writing or soliciting fake reviews;'
                '\n•	use the Services to upload, transmit, distribute, store or otherwise make available in any way: files that contain viruses, trojans, worms, logic bombs or other material that is malicious or technologically harmful;'
                '\n•	any unsolicited or unauthorized advertising, solicitations, promotional materials, “junk mail,” “spam,” “chain letters,” “pyramid schemes,” or any other prohibited form of solicitation;'
                '\n•	any private information of any third party, including addresses, phone numbers, email addresses, number and feature in the personal identity document (e.g., National Insurance numbers, passport numbers) or credit card numbers;'
                '\n•any material which does or may infringe any copyright, trademark or other intellectual property or privacy rights of any other person;'
                '\n•	any material which is defamatory of any person, obscene, offensive, pornographic, hateful or inflammatory;'
                '\n•	any material that would constitute, encourage or provide instructions for a criminal offence, dangerous activities or self-harm;'
                '\n•	any material that is deliberately designed to provoke or antagonize people, especially trolling and bullying, or is intended to harass, harm, hurt, scare, distress, embarrass or upset people;'
                '\n•	any material that contains a threat of any kind, including threats of physical violence;'
                '\n•	any material that is racist or discriminatory, including discrimination on the basis of someone’s race, religion, age, gender, disability or sexuality;'
                '\n•	any answers, responses, comments, opinions, analysis or recommendations that you are not properly licensed or otherwise qualified to provide; or'
                '\n•	material that, in the sole judgment of Smile, is objectionable or which restricts or inhibits any other person from using the Services, or which may expose Smile, the Services or its users to any harm or liability of any type.'
                'We reserve the right, at any time and without prior notice, to remove or disable access to content at our discretion for any reason or no reason. Some of the reasons we may remove or disable access to content may include finding the content objectionable, in violation of these Terms or our Community Policy, or otherwise harmful to the Services or our users. Our automated systems analyze your content (including emails) to provide you personally relevant product features, such as customized search results, tailored advertising, and spam and malware detection. This analysis occurs as the content is sent, received, and when it is stored.',
              ),
              _title(
                '6. Intellectual Property Rights',
              ),
              _body(
                'We respect intellectual property rights and ask you to do the same. As a condition of your access to and use of the Services.',
              ),
              _title(
                '7. Content',
              ),
              _body(
                'Smile Content As between you and Smile, all content, software, images, text, graphics, illustrations, logos, patents, trademarks, service marks, copyrights, photographs, audio, videos, music on and “look and feel” of the Services, and all intellectual property rights related thereto (the “Smile Content”), are either owned or licensed by Smile, it being understood that you or your licensors will own any User Content (as defined below) you upload or transmit through the Services. Use of the Smile Content or materials on the Services for any purpose not expressly permitted by these Terms is strictly prohibited. Such content may not be downloaded, copied, reproduced, distributed, transmitted, broadcast, displayed, sold, licensed or otherwise exploited for any purpose whatsoever without our or, where applicable, our licensors’ prior written consent. We and our licensors reserve all rights not expressly granted in and to their content.'
                'You acknowledge and agree that we may generate revenues, increase goodwill or otherwise increase our value from your use of the Services, including, by way of example and not limitation, through the sale of advertising, sponsorships, promotions, usage data and Gifts (defined below), and except as specifically permitted by us in these Terms or in another agreement you enter into with us, you will have no right to share in any such revenue, goodwill or value whatsoever. You further acknowledge that, except as specifically permitted by us in these Terms or in another agreement you enter into with us, you (I) have no right to receive any income or other consideration from any User Content (defined below) or your use of any musical works, sound recordings or audiovisual clips made available to you on or through the Services, including in any User Content created by you, and (ii) are prohibited from exercising any rights to monetize or obtain consideration from any User Content within the Services or on any third party service ( e.g. , you cannot claim User Content that has been uploaded to a social media platform such as YouTube for monetization).'
                'Subject to the terms and conditions of the Terms, you are hereby granted a non-exclusive, limited, non-transferable, non-sublicensable, revocable, worldwide license to access and use the Services, including to download the Platform on a permitted device, and to access the Smile Content solely for your personal, non-commercial use through your use of the Services and solely in compliance with these Terms. Smile reserves all rights not expressly granted herein in the Services and the Smile Content. You acknowledge and agree that Smile may terminate this license at any time for any reason or no reason.'
                'NO RIGHTS ARE LICENSED WITH RESPECT TO SOUND RECORDINGS AND THE MUSICAL WORKS EMBODIED THEREIN THAT ARE MADE AVAILABLE FROM OR THROUGH THE SERVICE.'
                'You acknowledge and agree that when you view content provided by others on the Services, you are doing so at your own risk. The content on our Services is provided for general information only. It is not intended to amount to advice on which you should rely. You must obtain professional or specialist advice before taking, or refraining from, any action on the basis of the content on our Services.'
                'We make no representations, warranties or guarantees, whether express or implied, that any Smile Content (including User Content) is accurate, complete or up to date. Where our Services contain links to other sites and resources provided by third parties, these links are provided for your information only. We have no control over the contents of those sites or resources. Such links should not be interpreted as approval by us of those linked websites or information you may obtain from them. You acknowledge that we have no obligation to pre-screen, monitor, review, or edit any content posted by you and other users on the Services (including User Content).'
                '\n\nUser-Generated Content\n'
                'Users of the Services may be permitted to upload, post or transmit (such as via a stream) or otherwise make available content through the Services including, without limitation, any text, photographs, user videos, sound recordings and the musical works embodied therein, including videos that incorporate locally stored sound recordings from your personal music library and ambient noise (“User Content”). Users of the Services may also extract all or any portion of User Content created by another user to produce additional User Content, including collaborative User Content with other users, that combine and intersperse User Content generated by more than one user. Users of the Services may also overlay music, graphics, stickers, Virtual Items (as defined and further explained Virtual Items Policy) and other elements provided by Smile (“Smile Elements”) onto this User Content and transmit this User Content through the Services. The information and materials in the User Content, including User Content that includes Smile Elements, have not been verified or approved by us. The views expressed by other users on the Services (including through use of the virtual gifts) do not represent our views or values.'
                'Whenever you access or use a feature that allows you to upload or transmit User Content through the Services (including via certain third-party social media platforms such as Instagram, Facebook, YouTube, Twitter), or to make contact with other users of the Services, you must comply with the standards set out at “Your Access to and Use of Our Services” above. You may also choose to upload or transmit your User Content, including User Content that includes Smile Elements, on sites or platforms hosted by third parties. If you decide to do this, you must comply with their content guidelines as well as with the standards set out at “Your Access to and Use of Our Services” above. As noted above, these features may not be available to all users of the Services, and we have no liability to you for limiting your right to certain features of the Services.'
                'You warrant that any such contribution does comply with those standards, and you will be liable to us and indemnify us for any breach of that warranty. This means you will be responsible for any loss or damage we suffer as a result of your breach of warranty.'
                'Any User Content will be considered non-confidential and non-proprietary. You must not post any User Content on or through the Services or transmit to us any User Content that you consider to be confidential or proprietary. When you submit User Content through the Services, you agree and represent that you own that User Content, or you have received all necessary permissions, clearances from, or are authorized by, the owner of any part of the content to submit it to the Services, to transmit it from the Services to other third party platforms, and/or adopt any third party content.'
                'If you only own the rights in and to a sound recording, but not to the underlying musical works embodied in such sound recordings, then you must not post such sound recordings to the Services unless you have all permissions, clearances from, or are authorized by, the owner of any part of the content to submit it to the Services'
                'You or the owner of your User Content still own the copyright in User Content sent to us, but by submitting User Content via the Services, you hereby grant us an unconditional irrevocable, non-exclusive, royalty-free, fully transferable, perpetual worldwide licence to use, modify, adapt, reproduce, make derivative works of, publish and/or transmit, and/or distribute and to authorise other users of the Services and other third-parties to view, access, use, download, modify, adapt, reproduce, make derivative works of, publish and/or transmit your User Content in any format and on any platform, either now known or hereinafter invented.'
                'You further grant us a royalty-free license to use your user’s name, image, voice, and likeness to identify you as the source of any of your User Content; provided, however, that your ability to provide an image, voice, and likeness may be subject to limitations due to age restrictions.'
                'For the avoidance of doubt, the rights granted in the preceding paragraphs of this Section include, but are not limited to, the right to reproduce sound recordings (and make mechanical reproductions of the musical works embodied in such sound recordings), and publicly perform and communicate to the public sound recordings (and the musical works embodied therein), all on a royalty-free basis. This means that you are granting us the right to use your User Content without the obligation to pay royalties to any third party, including, but not limited to, a sound recording copyright owner (e.g., a record label), a musical work copyright owner (e.g., a music publisher), a performing rights organization (e.g., ASCAP, BMI, SESAC, etc.) (a “PRO”), a sound recording PRO (e.g., Sound Exchange), any unions or guilds, and engineers, producers or other royalty participants involved in the creation of User Content.'
                'Specific Rules for Musical Works and for Recording Artists. If you are a composer or author of a musical work and are affiliated with a PRO, then you must notify your PRO of the royalty-free license you grant through these Terms in your User Content to us. You are solely responsible for ensuring your compliance with the relevant PRO’s reporting obligations. If you have assigned your rights to a music publisher, then you must obtain the consent of such music publisher to grant the royalty-free license(s) set forth in these Terms in your User Content or have such music publisher enter into these Terms with us. Just because you authored a musical work (e.g., wrote a song) does not mean you have the right to grant us the licenses in these Terms. If you are a recording artist under contract with a record label, then you are solely responsible for ensuring that your use of the Services is in compliance with any contractual obligations you may have to your record label, including if you create any new recordings through the Services that may be claimed by your label.'
                'Through-To-The-Audience Rights. All of the rights you grant in your User Content in these Terms are provided on a through-to-the-audience basis, meaning the owners or operators of third party services will not have any separate liability to you or any other third party for User Content posted or used on such third party service via the Services.'
                'Waiver of Rights to User Content. By posting User Content to or through the Services, you waive any rights to prior inspection or approval of any marketing or promotional materials related to such User Content. You also waive any and all rights of privacy, publicity, or any other rights of a similar nature in connection with your User Content, or any portion thereof. To the extent any moral rights are not transferable or assignable, you hereby waive and agree never to assert any and all moral rights, or to support, maintain or permit any action based on any moral rights that you may have in or with respect to any User Content you Post to or through the Services.We also have the right to disclose your identity to any third party who is claiming that any User Content posted or uploaded by you to our Services constitutes a violation of their intellectual property rights, or of their right to privacy.'
                'We, or authorized third parties, reserve the right to cut, crop, edit or refuse to publish, your content at our or their sole discretion. We have the right to remove, disallow, block or delete any posting you make on our Services if, in our opinion, your post does not comply with the content standards set out at “Your Access to and Use of Our Services “above. In addition, we have the right – but not the obligation – in our sole discretion to remove, disallow, block or delete any User Content (i) that we consider to violate these Terms, or (ii) in response to complaints from other users or third parties, with or without notice and without any liability to you. As a result, we recommend that you save copies of any User Content that you post to the Services on your personal device(s) in the event that you want to ensure that you have permanent access to copies of such User Content. We do not guarantee the accuracy, integrity, appropriateness or quality of any User Content, and under no circumstances will we be liable in any way for any User Content.'
                'You control whether your User Content is made publicly available on the Services to all other users of the Services or only available to people you approve. To restrict access to your User Content, you should select the privacy setting available within the Platform.'
                'We accept no liability in respect of any content submitted by users and published by us or by authorised third parties.'
                'Smile takes reasonable measures to expeditiously remove from our Services any infringing material that we become aware of.It is Smile’s policy, in appropriate circumstances and at its discretion, to disable or terminate the accounts of users of the Services who repeatedly infringe copyrights or intellectual property rights of others.'
                'While our own staff is continually working to develop and evaluate our own product ideas and features,'
                ''
                ' we pride ourselves on paying close attention to the interests, feedback, comments, and suggestions we'
                ' receive from the user community. If you choose to contribute by sending us or our employees any ideas for products,'
                ' services, features, modifications, enhancements, content, refinements, technologies, content offerings (such as audio, '
                'visual, games, or other types of content), promotions, strategies, or product/feature names, or any related documentation, '
                'artwork, computer code, diagrams, or other materials (collectively “Feedback”), then regardless of what your accompanying'
                ' communication may say, the following terms will apply, so that future misunderstandings can be avoided.'
                ' Accordingly, by sending Feedback to us, you agree that:'
                'Smile has no obligation to review, consider, or implement your Feedback, or to return to you all or part of any Feedback for any reason'
                'Feedback provided on a non-confidential basis, and we are not under any obligation to keep any Feedback you send confidential or to refrain from using or disclosing it in any way; and'
                'You irrevocably grant us perpetual and unlimited permission to reproduce, distribute, create derivative works of, modify, publicly perform (including on a through-to-the-audience basis), communicate to the public, make available, publicly display, and otherwise use and exploit the Feedback and derivatives thereof for any purpose and without restriction, free of charge and without attribution of any kind, including by making, using, selling, offering for sale, importing, and promoting commercial products and services that incorporate or embody Feedback, whether in whole or in part, and whether as provided or as modified',
              ),
              _title(
                '8. Indemnity',
              ),
              _body(
                'You agree to defend, indemnify, and hold harmless Smile, its parents, subsidiaries, and affiliates, and each of their respective officers, directors, employees, agents and advisors from any and all claims, liabilities, costs, and expenses, including, but not limited to, attorneys’ fees and expenses, arising out of a breach by you or any user of your account of these Terms or arising out of a breach of your obligations, representation and warranties under these Terms.',
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

_title(String text) {
  return TextSpan(
      text: text + '\n\n',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18));
}

_body(String text) {
  return TextSpan(text: text + '\n\n\n', style: TextStyle(fontSize: 18));
}
